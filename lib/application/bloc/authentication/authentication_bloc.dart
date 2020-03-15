import 'package:flutter/material.dart';
import 'package:memnder/application/mapper/mapper.dart';
import 'package:memnder/application/model/authentication_model.dart';
import 'package:memnder/application/model/service_response.dart';
import 'package:memnder/application/service/authentication_service.dart';
import 'package:memnder/application/validator/authentication_validator.dart';
import 'package:memnder/application/validator/form_validator.dart';
import 'package:memnder/application/view_model/authentication_view_model.dart';

import 'authentication_event.dart';
import 'authentication_state.dart';
import 'package:bloc/bloc.dart';

class AuthenticationBloc extends Bloc<AuthenticationEvent, AuthenticationState>{

  FormValidator<AuthenticationField> formValidator;
  Mapper<AuthenticationModel, AuthenticationViewModel> mapper;
  AuthenticationServiceInterface authenticationService;

  AuthenticationBloc(
    {
      @required this.formValidator,
      @required this.mapper,
      @required this.authenticationService
    }
  ){
    print("inited $this");
  }
  
  @override
  Future<void> close(){
    return super.close();
  }

  AuthenticationState get initialState => AuthenticationState();


  void authenticate(AuthenticationViewModel viewModel)async{
    var model = mapper.mapToModel(viewModel);
    var response = await authenticationService.authenticate(model);

    if (response is Success){
      add(Authenticated());
    } else if (response is Error){
      add(ReceivedError(
        message: response.message
      ));
    }
  }

  @override
  Stream<AuthenticationState> mapEventToState(AuthenticationEvent event) async* {
    if (event is AuthenticationAttempt){
      yield* _mapRegistrationAttemt(event);
    } else if (event is Authenticated){
      yield* _mapAuthenticated(event);
    } else if (event is ReceivedError){
      yield* _mapReceivedError(event);
    }
  }

  Stream<AuthenticationState> _mapReceivedError(ReceivedError event) async*{
     yield AuthenticationError(
       message: event.message
     );
   }

   Stream<AuthenticationState> _mapAuthenticated(Authenticated event) async*{
     yield AuthenticationSuccess();
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
      authenticate(event.authentication);
    }
  }

}
			