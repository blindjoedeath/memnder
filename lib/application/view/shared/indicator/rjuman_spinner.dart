import 'package:flutter/material.dart';
import 'dart:math';

class RjumanSpinner extends StatefulWidget {

  _RjumanSpinnerState _state;

  @override
  _RjumanSpinnerState createState() => _state = _RjumanSpinnerState();
}

class _RjumanSpinnerState extends State<RjumanSpinner>
    with SingleTickerProviderStateMixin {
  AnimationController _animationController;

  @override
  void didUpdateWidget(RjumanSpinner oldWidget) {
    _animationController.animateTo(oldWidget._state._animationController.value ?? 0.0);
    _animationController.repeat();
    super.didUpdateWidget(oldWidget);
  }
  
  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: new Duration(seconds: 1),
    );

    _animationController.repeat();
  }

  @override
  void dispose() { 
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print("build");
    return AnimatedBuilder(
      animation: _animationController,
      child: new Container(
        height: 100.0,
        width: 100.0,
        child: new Image.asset('assets/rjuman.png'),
      ),
      builder: (BuildContext context, Widget widget) {
        return new Transform.rotate(
          angle: _animationController.value * 2 * pi * 2,
          child: widget,
        );
      }
    );
  }
}