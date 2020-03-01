import 'package:flutter/material.dart';

class AuthenticationViewModel{
  final String login;
  final String password;

  const AuthenticationViewModel(
    {
      @required this.login,
      @required this.password,
    }
  );
}