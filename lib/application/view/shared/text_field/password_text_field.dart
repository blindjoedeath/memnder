
import 'package:flutter/material.dart';
import 'package:memnder/application/view/shared/text_field/form_text_field.dart';

class PasswordTextField extends FormTextField{

  const PasswordTextField(
  {
    String title = "Пароль",
    String error,
    @required TextEditingController controller,
  }) : super(
    controller: controller,
    title: title,
    error: error,
    inputType: TextInputType.visiblePassword,
    icon: const Icon(Icons.security),
    obscureText: true
  );

}