
import 'package:flutter/material.dart';

class AuthenticationModel{
  final String login;
  final String password;

  const AuthenticationModel(
    {
      @required this.login,
      @required this.password,
    }
  );
}