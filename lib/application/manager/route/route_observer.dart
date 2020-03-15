

import 'package:flutter/material.dart';
import 'package:memnder/application/assembly/assemler.dart';

enum RouteKey{
  routeType
}

enum RouteType{
  modal, noAnimation
}

class RouteDependencyObserver extends NavigatorObserver{

  static Assembler _assembler;

  static void inject(Assembler assembler){
    _assembler = assembler;
  }

  static Route<dynamic> _mapModal(RouteSettings route){
    return MaterialPageRoute(
      builder: (context){
        return _assembler.routes[route.name](context);
      },
      fullscreenDialog: true,
      settings: route
    );
  }

  static Route<dynamic> _mapNoAnimation(RouteSettings route){
    return PageRouteBuilder(
        pageBuilder: (context, animation1, animation2) => _assembler.routes[route.name](context),
    );
  }


  static Route<dynamic> onGenerateRoute(RouteSettings route){

    var map = route.arguments;
    if (map is Map){
      if (map.containsKey(RouteKey.routeType)){
        switch(map[RouteKey.routeType]){
          case RouteType.modal:
            return _mapModal(route);
          case RouteType.noAnimation:
            return _mapNoAnimation(route);
        }
      }
    }

    return MaterialPageRoute(
      builder: (context){
        return _assembler.routes[route.name](context);
      },
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