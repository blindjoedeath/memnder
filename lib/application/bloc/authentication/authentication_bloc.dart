import 'package:flutter/material.dart';
import 'package:memnder/application/mapper/mapper.dart';
import 'package:memnder/application/model/authentication_model.dart';
import 'package:memnder/application/validator/authentication_validator.dart';
import 'package:memnder/application/validator/form_validator.dart';
import 'package:memnder/application/view_model/authentication_view_model.dart';

import 'authentication_event.dart';
import 'authentication_state.dart';
import 'package:bloc/bloc.dart';

class AuthenticationBloc extends Bloc<AuthenticationEvent, AuthenticationState>{

  FormValidator<AuthenticationField> formValidator;
  Mapper<AuthenticationModel, AuthenticationViewModel> mapper;

  AuthenticationBloc(
    {
      @required this.formValidator,
      @required this.mapper
    }
  );

  AuthenticationState get initialState => AuthenticationState();

  @override
  Stream<AuthenticationState> mapEventToState(AuthenticationEvent event) async* {
    if (event is AuthenticationAttempt){
      yield* _mapRegistrationAttemt(event);
    }
  }

  Stream<AuthenticationState> _mapRegistrationAttemt(AuthenticationAttempt event) async*{
    var response = formValidator.validate({
      AuthenticationField.login : event.authentication.login,
      AuthenticationField.password : event.authentication.password,
    });

    if (response is FormValidationError<AuthenticationField>){
      yield AuthenticationValidationError(
        errorMessage: response.message,
        field: response.field
      );
    } else if (response is FormValidationSuccess){
      yield AuthenticationLoading();
    }
  }

}
			