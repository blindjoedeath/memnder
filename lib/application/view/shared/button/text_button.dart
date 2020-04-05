import 'package:flutter/material.dart';

class TextButton extends StatelessWidget{

  final Function onPressed;
  final String text;
  final ValueNotifier<bool> _isPressed = ValueNotifier(false);

  TextButton({@required this.text, @required this.onPressed});

  void _tapState(bool state){
    _isPressed.value = state;
    _isPressed.notifyListeners();
    if (!state){
      onPressed();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 212,
      child: GestureDetector(
        child: Container(
          height: 46,
          alignment: Alignment.center,
          child: ValueListenableBuilder(
            valueListenable: _isPressed,
            builder: (context, value, child){
              return AnimatedPadding(
                padding: EdgeInsets.only(top: value ? 5 : 0),
                duration: Duration(milliseconds: 50),
                child: child,
              );
            },
            child: Text(
              text,
              style: Theme.of(context).textTheme.button.copyWith(
                color: Colors.black54
              )
            )
          )
        ),
        onTapDown: (d) => _tapState(true),
        onTapUp: (d) => _tapState(false),
      )
    );
  }
}