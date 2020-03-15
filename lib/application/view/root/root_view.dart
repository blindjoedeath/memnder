import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:memnder/application/bloc/root/root_event.dart';
import 'package:memnder/application/bloc/root/root_state.dart';
import 'package:memnder/application/manager/route/route_manager.dart';
import 'package:memnder/application/manager/route/route_observer.dart';


class RootView extends StatefulWidget{

  final Bloc<RootEvent, RootState> bloc;

  const RootView(
    {
      @required this.bloc
    }
  );

  @override
  State<StatefulWidget> createState() => _RootViewState();

}

class _RootViewState extends State<RootView>{

  void _showApp()async{
    await RouteManager.prepareNamed("/app");
    Navigator.pushReplacementNamed(context, "/app",
      arguments: {
        RouteKey.routeType : RouteType.noAnimation
      }
    );
  }

  void _showAuthentication()async{
    await RouteManager.prepareNamed("/authentication");
    Navigator.pushReplacementNamed(context, "/authentication",
      arguments: {
        RouteKey.routeType : RouteType.noAnimation
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<Bloc<RootEvent, RootState>, RootState>(
      bloc: widget.bloc,
      builder: (context, state){
        if (state.isAuthenticated){
          _showApp();
        } else{
          _showAuthentication();
        }
        return Scaffold();
      },
    );
  }

}
			