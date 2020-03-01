import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:memnder/application/bloc/registration/registration_bloc.dart';
import 'package:memnder/application/bloc/registration/registration_event.dart';
import 'package:memnder/application/bloc/registration/registration_state.dart';
import 'package:memnder/application/validator/registration_validator.dart';
import 'package:memnder/application/view/shared/button/sign_button.dart';
import 'package:memnder/application/view/shared/text_field/login_text_field.dart';
import 'package:memnder/application/view/shared/text_field/password_text_field.dart';
import 'package:memnder/application/view_model/registration_view_model.dart';

class RegistrationView extends StatefulWidget{

  final Bloc<RegistrationEvent, RegistrationState> bloc;

  const RegistrationView({@required this.bloc});

  @override
  State<StatefulWidget> createState() => _RegistrationViewState();

}

class _RegistrationViewState extends State<RegistrationView>{

  final TextEditingController _loginController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _password2Controller = TextEditingController();

  void _onLogin(){
    var registration = RegistrationViewModel(
      login: _loginController.text ?? "",
      password: _passwordController.text ?? "",
      passwordConfirmation: _password2Controller.text ?? ""
    );
    widget.bloc.add(RegistrationAttempt(
      registration: registration
    ));
  }

  Widget _buildForm(RegistrationState state) {
    Map<RegistrationField, String> errors = Map();
    if (state is RegistrationValidationError){
      errors[state.field] = state.errorMessage;
    }
    return ListView(
      children: <Widget>[
        SizedBox(
          height: 56,
        ),
        LoginTextField(
          controller: _loginController,
          error: errors[RegistrationField.login],
        ),
        SizedBox(
          height: 12,
        ),
        PasswordTextField(
          controller: _passwordController,
          error: errors[RegistrationField.password],
        ),
        SizedBox(
          height: 12,
        ),
        PasswordTextField(
          controller: _password2Controller,
          title: "Повторите пароль",
          error: errors[RegistrationField.passwordConfirmation],
        ),
        SizedBox(
          height: 12,
        ),
        SignButton(
          onPressed: _onLogin,
          title: "Зарегистрироваться",
        ),
        Padding(
          padding: EdgeInsets.only(top: 46),
          child: Center(
            child: state is RegistrationLoading ? CircularProgressIndicator()
                                                  : Container()
          )
        )
      ],
    );
  }

  void routeToAccount(){
    WidgetsBinding.instance.addPostFrameCallback((d){
      Navigator.pop(context);
    });
  }

  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  void showEror(String message){
    WidgetsBinding.instance.addPostFrameCallback((d){
      _scaffoldKey.currentState.showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text("Ошибка" + (message != null ? ": $message" : ""))
        )
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(title: Text("Регистрация"),),
      body: BlocBuilder<Bloc<RegistrationEvent, RegistrationState>, RegistrationState>(
        bloc: widget.bloc,
        builder: (context, state){ 
          if (state is RegistrationSuccess){
            routeToAccount();
          } else if (state is RegistrationError){
            showEror(state.message);
          }
          return _buildForm(state);
        }
      )
    );
  }

}