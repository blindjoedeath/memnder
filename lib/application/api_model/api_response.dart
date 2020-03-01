

import 'package:flutter/material.dart';

class ApiResponse{}

class ApiSuccess<T> extends ApiResponse{
  final T value;

  ApiSuccess({@required this.value});
}

class ApiError extends ApiResponse{}

class CredentialsError extends ApiError{}

class ApiErrorDetail extends ApiError{
  final String message;
  final int statusCode;

  ApiErrorDetail({this.message, this.statusCode});
}