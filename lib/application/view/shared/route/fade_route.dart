

import 'package:flutter/material.dart';

class FadeRoute extends PageRouteBuilder{

  final Widget Function(BuildContext, Animation<double>, Animation<double>) pageBuilder;

  FadeRoute({@required this.pageBuilder}) : 
    super(
      pageBuilder: pageBuilder,
        transitionsBuilder: (c, anim, a2, child) => FadeTransition(
          opacity: CurvedAnimation(
            curve: Curves.fastOutSlowIn,
            parent: anim,
          ),
          child: child
        ),
        transitionDuration: Duration(milliseconds: 350),
    );

}