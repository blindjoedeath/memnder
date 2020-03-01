import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:memnder/application/bloc/authentication/authentication_bloc.dart';
import 'package:memnder/application/bloc/authentication/authentication_event.dart';
import 'package:memnder/application/bloc/authentication/authentication_state.dart';
import 'package:memnder/application/validator/authentication_validator.dart';
import 'package:memnder/application/validator/registration_validator.dart';
import 'package:memnder/application/view/shared/button/sign_button.dart';
import 'package:memnder/application/view/shared/button/text_button.dart';
import 'package:memnder/application/view/shared/text_field/login_text_field.dart';
import 'package:memnder/application/view/shared/text_field/password_text_field.dart';
import 'package:memnder/application/view_model/authentication_view_model.dart';

class AuthenticationView extends StatefulWidget{

  final AuthenticationBloc bloc;

  const AuthenticationView({@required this.bloc});

  @override
  State<StatefulWidget> createState() => _AuthenticationViewState();

}

class _AuthenticationViewState extends State<AuthenticationView>{

  final TextEditingController _loginController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _onLogin(){
    var authentication = AuthenticationViewModel(
      login: _loginController.text ?? "",
      password: _passwordController.text ?? "",
    );
    widget.bloc.add(AuthenticationAttempt(
      authentication: authentication
    ));
  }

  void _onRegister()async{
    Navigator.pushNamed(context, "/registration");
  }

  Widget _buildForm() {
    return BlocBuilder<AuthenticationBloc, AuthenticationState>(
      bloc: widget.bloc,
      builder: (context, state){
        Map<AuthenticationField, String> errors = Map();
        if (state is AuthenticationValidationError){
          errors[state.field] = state.errorMessage;
        }
        return ListView(
          children: <Widget>[
            SizedBox(
              height: 56,
            ),
            LoginTextField(
              controller: _loginController,
              error: errors[AuthenticationField.login],
            ),
            SizedBox(
              height: 12,
            ),
            PasswordTextField(
              controller: _passwordController,
              error: errors[AuthenticationField.password],
            ),
            TextButton(
              onPressed: _onRegister,
              text: "Зарегистрироваться",
            ),
            SignButton(
              onPressed: _onLogin,
              title: "Войти",
            ),
            Padding(
              padding: EdgeInsets.only(top: 46),
              child: Center(
                child: state is AuthenticationLoading ? CircularProgressIndicator()
                                                     : Container()
              )
            )
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Аутентификация"),),
      body: _buildForm(),
    );
  }

}