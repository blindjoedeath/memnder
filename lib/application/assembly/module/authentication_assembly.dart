import 'package:dioc/src/container.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:memnder/application/assembly/assembly.dart';
import 'package:memnder/application/bloc/authentication/authentication_bloc.dart';
import 'package:memnder/application/bloc/authentication/authentication_event.dart';
import 'package:memnder/application/bloc/authentication/authentication_state.dart';
import 'package:memnder/application/bloc/registration/registration_bloc.dart';
import 'package:memnder/application/mapper/mapper.dart';
import 'package:memnder/application/model/authentication_model.dart';
import 'package:memnder/application/service/authentication_service.dart';
import 'package:memnder/application/validator/authentication_validator.dart';
import 'package:memnder/application/validator/form_validator.dart';
import 'package:memnder/application/validator/registration_validator.dart';
import 'package:memnder/application/view/authentication/authentication_view.dart';
import 'package:memnder/application/view/registration/registration_view.dart';
import 'package:memnder/application/extension/dioc//dioc_widget.dart';
import 'package:memnder/application/view_model/authentication_view_model.dart';

class AuthenticationAssembly extends ModuleAssembly<AuthenticationView>{

  Bloc<AuthenticationEvent, AuthenticationState> _authenticationBloc;

  @override
  void assemble(Container container) {

    registerAsync((c)async{
      var service = c.get<AuthenticationServiceInterface>();
      await service.init();
    });

    container.register<Bloc<AuthenticationEvent, AuthenticationState>>((c){
      return AuthenticationBloc(
        authenticationService: c.get<AuthenticationServiceInterface>(),
        mapper: c.get<Mapper<AuthenticationModel, AuthenticationViewModel>>(),
        formValidator: c.get<FormValidator<AuthenticationField>>(),
      );
    });

    container.registerBuilder<AuthenticationView>((context, c){
      return AuthenticationView(
        bloc: _authenticationBloc = c.create(),
      );
    });
  }

  @override 
  void unload(Container container) {
    _authenticationBloc.close();
  }

}