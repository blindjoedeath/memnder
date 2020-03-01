
import 'package:flutter/material.dart';

class RegistrationModel{
  final String login;
  final String password;

  const RegistrationModel(
    {
      @required this.login,
      @required this.password,
    }
  );
}