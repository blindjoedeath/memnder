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

    test();

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

abstract class Service{
}

class Service1 extends Service {
  Service1(){
    print("initing $this");
  }
}

class Service2 extends Service {
  Service2(){
    print("initing $this");
  }
}

test(){

  var container = dioc.Container();
  container.register<Service>((c) => Service1());

  Service s1 = container.create();

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
    print("remove");
    super.didRemove(route, previousRoute);
  }

  @override
  void didReplace({Route newRoute, Route oldRoute}) {
    print("replace");
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
  }

}