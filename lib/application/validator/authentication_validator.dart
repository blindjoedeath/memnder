import 'package:memnder/application/validator/form_validator.dart';

enum AuthenticationField{
  login,
  password,
}

class AuthenticationValidator extends FormValidator<AuthenticationField>{

  FormValidationResponse<AuthenticationField> validate(Map<AuthenticationField, dynamic> form){
    var login = form[AuthenticationField.login] as String;
    var password = form[AuthenticationField.password] as String;

    if ([login, password].any((x) => x == null)){
      return FormTypeError();
    }

    if (login.isEmpty){
      return FormValidationError(
        message: "Логин не может быть пустым",
        field: AuthenticationField.login
      );
    }

    if (login.contains(' ')){
      return FormValidationError(
        message: "Логин не может содержать пробелов",
        field: AuthenticationField.login
      );
    }

    if (password.isEmpty){
      return FormValidationError(
        message: "Пароль пустой",
        field: AuthenticationField.password
      );
    }

    return FormValidationSuccess();
  }

}