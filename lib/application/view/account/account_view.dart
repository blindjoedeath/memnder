

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:memnder/application/bloc/account/account_event.dart';
import 'package:memnder/application/bloc/account/account_state.dart';
import 'package:memnder/application/manager/route/route_manager.dart';
import 'package:memnder/application/view/shared/button/sign_button.dart';

class AccountView extends StatefulWidget{

  final Bloc<AccountEvent, AccountState> bloc;

  const AccountView(
    {
      @required this.bloc
    }
  );

  @override
  State<StatefulWidget> createState() => _AccountViewState();

}

class _AccountViewState extends State<AccountView>{

  Widget _buildBody(){
    return GridView.builder(
      padding: EdgeInsets.all(4),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 4,
        mainAxisSpacing: 4,
      ),
      itemBuilder: (context, index){
        return GridTile(
          footer: Container(
            padding: EdgeInsets.all(2),
            alignment: Alignment.bottomRight,
            child: Container(
              width: 20,
              height: 20,
              alignment: Alignment.center,
              child: Text("3", style: Theme.of(context).textTheme.caption),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white10,
              ),
            ),
          ),
          child: Container(
            color: Colors.indigoAccent
          ),
        );
      }
    );
  }

  void _logout()async{
    widget.bloc.add(Logout());
    await RouteManager.prepareNamed("/authentication");
    Navigator.pushReplacementNamed(context, "/authentication");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Мои мемы"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: _logout,
          )
        ],
      ),
      body: _buildBody(),
    );
  }

}