

import 'package:flutter/material.dart';

class AuthenticationApiModel{
  final String refresh;
  final String access;

    const AuthenticationApiModel(
    {
      @required this.refresh,
      @required this.access,
    }
  );

  factory AuthenticationApiModel.fromJson(Map<String, dynamic> json) {
    return AuthenticationApiModel(
      refresh: json["refresh"],
      access: json["access"]
    );
  }
}