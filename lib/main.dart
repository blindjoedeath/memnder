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

    RouteManager.inject(assembler);
    var routes = assembler.generateRoutes();

    return FutureBuilder(
      future: RouteManager.prepareNamed("/"),
      builder: (context, snapshot){
        if (snapshot.connectionState == ConnectionState.done){
          return MaterialApp(
            title: 'Memnder',
            initialRoute: "/",
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