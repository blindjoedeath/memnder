
import 'package:flutter/material.dart';

class RegistrationModel{
  final String login;
  final String password;
  final String passwordConfirmation;

  const RegistrationModel(
    {
      @required this.login,
      @required this.password,
      @required this.passwordConfirmation
    }
  );
}