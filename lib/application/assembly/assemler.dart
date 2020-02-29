
import 'package:dioc/dioc.dart';
import 'package:flutter/material.dart' hide Container;
import 'package:memnder/application/assembly/assembly.dart';
import 'package:memnder/application/assembly/home_assembly.dart';
import 'package:memnder/main.dart';

class Assembler{
  
  Map<String, ModuleAssembly> routes = {
    "/" : HomeAssembly(),
  };

  Container container;

  Map<String, Widget Function(BuildContext)> generateRoutes(){

    container = Container();

    routes.forEach((key, value){
      value.assemble(container);
    });

    return routes.map((key, value){
      return MapEntry(key, (c) => value.getView(c, container));
    });
  }

  Future prepareNamed(String route){
    return routes[route].prepare(container);
  }

}