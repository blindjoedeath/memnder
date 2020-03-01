

import 'package:flutter/material.dart';

class RegistrationApiModel{
  final int id;
  final String username;
  final String refresh;
  final String access;

  const RegistrationApiModel(
    {
      @required this.id,
      @required this.username,
      @required this.refresh,
      @required this.access
    }
  );

  factory RegistrationApiModel.fromJson(Map<String, dynamic> json) {
    return RegistrationApiModel(
      id: json['id'],
      username: json["username"],
      refresh: json["refresh"],
      access: json["access"]
    );
  }

}