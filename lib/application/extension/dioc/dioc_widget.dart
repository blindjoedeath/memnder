

import 'package:dioc/dioc.dart';
import 'package:flutter/material.dart' hide Container;

extension WidgetInjection<T extends Widget> on Container{
  void registerBuilder<T>(T Function(BuildContext, Container) builder){
    this.register<T Function(BuildContext, Container)>((c) => builder);
  }
  
  T getWidget<T>(BuildContext context){
    var builder = this.get<T Function(BuildContext, Container)>();
    return builder(context, this);
  }
}
