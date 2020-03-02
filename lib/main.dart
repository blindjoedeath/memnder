import 'package:dioc/dioc.dart' as dioc;
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:memnder/application/assembly/assemler.dart';
import 'package:memnder/application/manager/route_manager.dart';
import 'package:memnder/application/model/registration_model.dart';

void main(){
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    var assembler = Assembler();

    RouteObserver.inject(assembler);
    RouteManager.inject(assembler);
    var routes = assembler.generateRoutes();

    return FutureBuilder(
      future: RouteManager.prepareNamed("/"),
      builder: (context, snapshot){
        if (snapshot.connectionState == ConnectionState.done){
          return MaterialApp(
            title: 'Memnder',
            navigatorObservers: [RouteObserver()],
            theme: ThemeData(
              primarySwatch: Colors.blue,
            ),
            routes: routes,
          );
        } else{
          return Container(
            color: Colors.white,
          );
        }
      },
    );
  }
}

class RouteObserver extends NavigatorObserver{

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
    print("Did remove");
    super.didRemove(route, previousRoute);
  }

  @override
  void didReplace({Route newRoute, Route oldRoute}) {
    print("did replace");
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
  }

}