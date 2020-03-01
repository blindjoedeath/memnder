

import 'package:flutter/material.dart';

class SignButton extends StatelessWidget{

  final Function onPressed;
  final String title;

  const SignButton({this.title = "Войти", @required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(right: 72, left: 72),
      child: MaterialButton(
        onPressed: onPressed,
        child: Text(title),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12), 
        ),
        color: Colors.lightBlue,
        textColor: Colors.white,
        height: 40,
      ),
    );
  }
}