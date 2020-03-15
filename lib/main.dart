import 'package:dioc/dioc.dart' as dioc;
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart' as http;
import 'package:memnder/application/assembly/assemler.dart';
import 'package:memnder/application/manager/route/route_manager.dart';
import 'package:memnder/application/manager/route/route_observer.dart';
void main(){
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    var assembler = Assembler();

    RouteDependencyObserver.inject(assembler);
    RouteManager.inject(assembler);
    var routes = assembler.routes;

    EasyLoading.instance.. 
        loadingStyle = EasyLoadingStyle.custom
        ..backgroundColor = Colors.black26
        ..indicatorColor = Colors.white
        ..progressColor = Colors.white
        ..textColor = Colors.white
        ..userInteractions = false;

    return FutureBuilder(
      future: RouteManager.prepareNamed("/"),
      builder: (context, snapshot){
        if (snapshot.connectionState == ConnectionState.done){
          return FlutterEasyLoading(
            child: MaterialApp(
              title: 'Memnder',
              navigatorObservers: [RouteDependencyObserver()],
              theme: ThemeData(
                primarySwatch: Colors.blue,
              ),
              onGenerateRoute: RouteDependencyObserver.onGenerateRoute,
            )
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