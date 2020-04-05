

import 'package:flutter/material.dart';

enum FlyAnimationDirection{
  left,
  right
}

class FlyAnimationController extends AnimationController{


  FlyAnimationController(
    {
      @required TickerProvider vsync
    }
  ) : super(
    duration: Duration(milliseconds: 250),
    vsync: vsync
  );

  FlyAnimationDirection direction = FlyAnimationDirection.left; 
}

class FlyAnimation extends StatefulWidget{

  final Widget child;
  final FlyAnimationController controller;

  const FlyAnimation(
    {
      @required this.child,
      @required this.controller
    }
  );

  @override
  State<StatefulWidget> createState() => _FlyAnimationState();

}

class _FlyAnimationState extends State<FlyAnimation> with SingleTickerProviderStateMixin{

  Animation<double> _fadeAnimation;
  Animation<double> _scaleAnimation;
  CurvedAnimation _curve;

  Animation<Offset> get _slideAnimation{
    double sign = widget.controller.direction == FlyAnimationDirection.left ? -1 : 1;
    return Tween<Offset>(
      begin: const Offset(0, 0),
      end: Offset(sign * 1, 0.1),
    ).animate(_curve);
  }

  void _controllerListener(){
    setState(() {});
  }

  @override
  void initState() {

    _curve = CurvedAnimation(
      curve: Curves.decelerate,
      parent: widget.controller
    );

    _fadeAnimation = ReverseTween(
      Tween(
        begin: 0.0, end: 1.0
      )
    ).animate(_curve);

    _scaleAnimation = Tween(
        begin: 1.0, end: 1.1
    ).animate(_curve);

    widget.controller.addListener(_controllerListener);

    super.initState();
  }

  @override
  void dispose() {
    widget.controller.removeListener(_controllerListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: ScaleTransition(
          scale: _scaleAnimation,
          child: widget.child,
        )
      )
    );
  }

}