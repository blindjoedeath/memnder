import 'package:dioc/dioc.dart' as dioc;
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:memnder/application/assembly/assemler.dart';
import 'package:memnder/application/manager/route_manager.dart';
import 'package:memnder/application/manager/route_observer.dart';
import 'package:memnder/application/provider/api_base_provider.dart';

void main(){
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    var assembler = Assembler();

    RouteDependencyObserver.inject(assembler);
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