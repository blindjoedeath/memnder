
import 'package:flutter/material.dart';
import 'package:memnder/application/validator/form_validator.dart';

enum RegistrationField{
  login,
  password,
  passwordConfirmation
}

class RegistrationValidator extends FormValidator<RegistrationField>{

  FormValidationResponse<RegistrationField> validate(Map<RegistrationField, dynamic> form){
    var login = form[RegistrationField.login] as String;
    var password = form[RegistrationField.password] as String;
    var passwordConfirm = form[RegistrationField.passwordConfirmation] as String;

    if ([login, password, passwordConfirm].any((x) => x == null)){
      return FormTypeError();
    }

    if (login.isEmpty){
      return FormValidationError(
        message: "Логин не может быть пустым",
        field: RegistrationField.login
      );
    }

    if (login.contains(' ')){
      return FormValidationError(
        message: "Логин не может содержать пробелов",
        field: RegistrationField.login
      );
    }

    if (login.length > 32){
      return FormValidationError(
        message: "Слишком большой логин",
        field: RegistrationField.login
      );
    }

    if (password.isEmpty){
      return FormValidationError(
        message: "Пароль пустой",
        field: RegistrationField.password
      );
    }

    if (password.length < 6){
      return FormValidationError(
        message: "Пароль слишком маленький",
        field: RegistrationField.password
      );
    }

    if (password.length > 100){
      return FormValidationError(
        message: "Пароль слишком большой",
        field: RegistrationField.password
      );
    }

    if (password != passwordConfirm){
      return FormValidationError(
        message: "Пароли не совпадают",
        field: RegistrationField.passwordConfirmation
      );
    }

    return FormValidationSuccess();
  }

}