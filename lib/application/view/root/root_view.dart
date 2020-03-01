

import 'package:flutter/material.dart';
import 'package:memnder/application/bloc/authentication/authentication_bloc.dart';
import 'package:memnder/application/bloc/registration/registration_bloc.dart';
import 'package:memnder/application/entity/lazy/lazy.dart';
import 'package:memnder/application/manager/route_manager.dart';
import 'package:memnder/application/view/authentication/authentication_view.dart';
import 'package:memnder/application/view/registration/registration_view.dart';

class RootView extends StatefulWidget{ 
  final Lazy<AuthenticationBloc> authenticationBloc;

  const RootView({@required this.authenticationBloc});

  @override
  State<StatefulWidget> createState() => _RootViewState();

}

class _RootViewState extends State<RootView>{

  int index = 0;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: index == 0 ? AuthenticationView(
        bloc: widget.authenticationBloc.instance
      ) : AuthenticationView(
        bloc: widget.authenticationBloc.instance
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: index,
        onTap: (i) => setState(() => index = i),
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            title: Text("Аккаунт")
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.tag_faces),
            title: Text("Мемы")
          )
        ],
      ),
    );
  }
}