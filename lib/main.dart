import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:memnder/application/assembly/assemler.dart';
import 'package:memnder/application/manager/route/route_manager.dart';
import 'package:memnder/application/manager/route/route_observer.dart';
import 'package:flutter/foundation.dart' show kIsWeb;


void main(){
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    
    var assembler = Assembler();
    RouteDependencyObserver.inject(assembler);
    RouteManager.inject(assembler);

    EasyLoading.instance.. 
        loadingStyle = EasyLoadingStyle.custom
        ..backgroundColor = Colors.black26
        ..indicatorColor = Colors.white
        ..progressColor = Colors.white
        ..textColor = Colors.white
        ..userInteractions = false;
    var futures = [RouteManager.prepareNamed("/")];
    if (!kIsWeb){
      futures.add(SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp
      ]));
    }

    return FutureBuilder(
      future: Future.wait(futures),
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