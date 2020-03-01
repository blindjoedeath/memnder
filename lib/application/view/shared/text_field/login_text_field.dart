import 'package:flutter/material.dart';
import 'package:memnder/application/view/shared/text_field/form_text_field.dart';

class LoginTextField extends FormTextField{

  const LoginTextField(
    {
      String title = "Юзернейм",
      String error,
      @required TextEditingController controller,
  }) : super(
    controller: controller,
    title: title,
    error: error,
    inputType: TextInputType.emailAddress,
    icon: const Icon(Icons.supervised_user_circle)
  );
}