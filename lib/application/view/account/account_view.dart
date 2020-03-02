

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:memnder/application/bloc/account/account_event.dart';
import 'package:memnder/application/bloc/account/account_state.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Аккаунт"),
      ),
      body: Center(
        child: SignButton(
          title: "Выйти",
          onPressed: () {
            widget.bloc.add(Logout());
          },
        ),
      ),
    );
  }

}