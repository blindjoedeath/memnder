import 'package:dioc/dioc.dart' as dioc;
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:memnder/application/assembly/assemler.dart';
import 'package:memnder/application/manager/route_manager.dart';

void main(){
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    var assembler = Assembler();

    RouteManager.inject(assembler);

    return MaterialApp(
      title: 'Flutter Demo',
      initialRoute: "/",
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      routes: assembler.generateRoutes(),
    );
  }
}