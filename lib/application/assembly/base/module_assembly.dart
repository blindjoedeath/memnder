

import 'package:dioc/dioc.dart';
import 'package:flutter/material.dart' hide Container;
import 'package:memnder/application/assembly/assembly.dart';
import 'package:memnder/application/assembly/base/assembly.dart';
import 'package:memnder/application/extension/dioc/dioc_widget.dart';

abstract class ModuleAssembly<T extends Widget> extends Assembly{

  List<Future<void> Function(Container)> _asyncInjections = List<Future<void> Function(Container)>();
  void registerAsync(Future<void> Function(Container) injection){
    _asyncInjections.add(injection);
  }

  Future prepare(Container container) {
    return Future.forEach(_asyncInjections, (i) async{
       await i(container);
    });
  }

  void unload(Container container){}

  T getView(BuildContext context, Container container){
    return container.getWidget<T>(context);
  }
}