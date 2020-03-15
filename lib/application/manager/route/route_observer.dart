

import 'package:flutter/material.dart';
import 'package:memnder/application/assembly/assemler.dart';

enum RouteKey{
  routeType
}

enum RouteType{
  modal
}

class RouteDependencyObserver extends NavigatorObserver{

  static Assembler _assembler;

  static void inject(Assembler assembler){
    _assembler = assembler;
  }

  static Route<dynamic> onGenerateRoute(RouteSettings route){

    var isModal = false;
    var map = route.arguments;
    if (map is Map){
      if (map.containsKey(RouteKey.routeType) && map[RouteKey.routeType] == RouteType.modal){
        isModal = true;
      }
    }

    return MaterialPageRoute(
      builder: (context){
        return _assembler.routes[route.name](context);
      },
      fullscreenDialog: isModal,
      settings: route
    );
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