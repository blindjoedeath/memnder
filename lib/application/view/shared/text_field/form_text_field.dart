import 'package:flutter/material.dart';

class FormTextField extends StatelessWidget{

  final Icon icon;
  final TextInputType inputType;
  final String title;
  final TextEditingController controller;
  final String error;
  final bool obscureText;

  const FormTextField(
    {
      @required this.title,
      @required this.controller,
      @required this.inputType,
      @required this.icon,
      this.obscureText = false,
      this.error = null,});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(right: 56, left: 56),
      child: TextField(
        controller: controller,
        keyboardType: inputType,
        textInputAction: TextInputAction.done,
        decoration: InputDecoration(
          errorText: error,
          prefixIcon: icon,
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          border: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.red),
            borderRadius: BorderRadius.circular(12)
          ),
          labelText: title,
        ),
        obscureText: obscureText,
      ),
    );
  }

}