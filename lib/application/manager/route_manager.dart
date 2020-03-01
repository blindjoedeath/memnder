import 'package:flutter/material.dart';
import 'package:memnder/application/assembly/assemler.dart';

class RouteManager{

  static Assembler _assembler;

  static void inject(Assembler assembler){
    _assembler = assembler;
  }

  static Future prepareNamed(String route){
    print("preparing");
    return _assembler.prepareNamed(route);
  }

}