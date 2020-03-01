import 'package:flutter/material.dart';
import 'package:memnder/application/mapper/mapper.dart';
import 'package:memnder/application/model/registration_model.dart';
import 'package:memnder/application/service/registration_service.dart';
import 'package:memnder/application/validator/form_validator.dart';
import 'package:memnder/application/validator/registration_validator.dart';
import 'package:memnder/application/view_model/registration_view_model.dart';

import 'registration_event.dart';
import 'registration_state.dart';
import 'package:bloc/bloc.dart';

class RegistrationBloc extends Bloc<RegistrationEvent, RegistrationState>{

  final FormValidator<RegistrationField> formValidator;
  final Mapper<RegistrationModel, RegistrationViewModel> mapper;
  final RegistrationServiceInterface registrationService;

  RegistrationBloc(
    {
      @required this.formValidator,
      @required this.mapper,
      @required this.registrationService
    }
  );

  @override
  Future<void> close(){
    super.close();
    print("Close registration bloc");
  }

  RegistrationState get initialState => RegistrationState();

  @override
  Stream<RegistrationState> mapEventToState(RegistrationEvent event) async* {
    if (event is RegistrationAttempt){
      yield* _mapRegistrationAttemt(event);
    }
  }

  Stream<RegistrationState> _mapRegistrationAttemt(RegistrationAttempt event) async*{
    var response = formValidator.validate({
      RegistrationField.login : event.registration.login,
      RegistrationField.password : event.registration.password,
      RegistrationField.passwordConfirmation : event.registration.passwordConfirmation,
    });

    if (response is FormValidationError<RegistrationField>){
      yield RegistrationValidationError(
        errorMessage: response.message,
        field: response.field
      );
    } else if (response is FormValidationSuccess){
      yield RegistrationLoading();
    }
  }

}
			