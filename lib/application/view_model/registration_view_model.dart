import 'package:flutter/material.dart';

class RegistrationViewModel{
  final String login;
  final String password;
  final String passwordConfirmation;

  const RegistrationViewModel(
    {
      @required this.login,
      @required this.password,
      @required this.passwordConfirmation
    }
  );
}