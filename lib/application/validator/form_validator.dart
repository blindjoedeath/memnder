import 'package:flutter/material.dart';

class FormValidationResponse<FormField>{}

class FormTypeError<FormField> extends FormValidationResponse<FormField>{
  final String message;
  final FormField field;

  FormTypeError({this.message, this.field});
}

class FormValidationError<FormField> extends FormValidationResponse<FormField>{
  final String message;
  final FormField field;

  FormValidationError({this.message, @required this.field});
}

class FormValidationSuccess<FormField> extends FormValidationResponse<FormField>{}

abstract class FormValidator<FormField>{

  FormValidationResponse<FormField> validate(Map<FormField, dynamic> form);

}