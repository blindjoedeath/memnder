

import 'package:flutter/material.dart';
import 'package:memnder/application/assembly/assemler.dart';

class RouteDependencyObserver extends NavigatorObserver{

  static Assembler _assembler;

  static void inject(Assembler assembler){
    _assembler = assembler;
  }

  @override
  void didPop(Route route, Route previousRoute) {
    print(route.settings.name);
    _assembler.unloadNamed(route.settings.name);
    super.didPop(route, previousRoute);
  }

  @override
  void didRemove(Route route, Route previousRoute) {
    print("remove");
    super.didRemove(route, previousRoute);
  }

  @override
  void didReplace({Route newRoute, Route oldRoute}) {
    print("replace");
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
  }

}