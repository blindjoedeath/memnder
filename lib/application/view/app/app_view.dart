import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:memnder/application/bloc/account/account_event.dart';
import 'package:memnder/application/bloc/account/account_state.dart';
import 'package:memnder/application/bloc/memes/memes_event.dart';
import 'package:memnder/application/bloc/memes/memes_state.dart';
import 'package:memnder/application/entity/lazy.dart';
import 'package:memnder/application/bloc/authentication/authentication_event.dart';
import 'package:memnder/application/bloc/authentication/authentication_state.dart';
import 'package:memnder/application/bloc/app/app_event.dart';
import 'package:memnder/application/bloc/app/app_state.dart';
import 'package:memnder/application/manager/route/route_manager.dart';
import 'package:memnder/application/manager/route/route_observer.dart';
import 'package:memnder/application/view/account/account_view.dart';
import 'package:memnder/application/view/authentication/authentication_view.dart';
import 'package:memnder/application/view/memes/memes_view.dart';

class AppView extends StatefulWidget{ 
  final Lazy<Bloc<MemesEvent, MemesState>> memesBloc;
  final Lazy<Bloc<AccountEvent, AccountState>> accountBloc;
  final  Bloc<AppEvent, AppState> bloc;

  const AppView(
    {
      @required this.bloc,
      @required this.memesBloc,
      @required this.accountBloc, 
    }
  );

  @override
  State<StatefulWidget> createState() => _AppViewState();

}

class _AppViewState extends State<AppView>{

  int index = 0;

  Widget _buildThirdTab(){
    return AccountView(
      bloc: widget.accountBloc.instance
    );
  }

  Future _showSecondTab()async{
    await RouteManager.prepareNamed("/app/load_meme");
    Navigator.pushNamed(context, "/app/load_meme",
      arguments: {
        RouteKey.routeType : RouteType.modal
      });
  }

  Future<Widget> _buildFirstTab()async{
    await RouteManager.prepareNamed("/app/memes");
    return MemesView(
      bloc: widget.memesBloc.instance
    );
  }

  @override
  void initState(){
    super.initState();

    _buildFirstTab().then((tab){
      _currentBody = tab;
      setState(() {});
    });
  }

  Widget _currentBody;
  void _onTap(int i)async{
    if (i != 1){
      index = i;
    }
    if (i == 0){
      _currentBody = await _buildFirstTab();
    } else if (i == 1){
      await _showSecondTab();
    } else {
      _currentBody = _buildThirdTab();
    } 
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<Bloc<AppEvent, AppState>, AppState>(
      bloc: widget.bloc,
      builder: (context, state){
        return Scaffold(
          body: _currentBody,
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: index,
            onTap: (i) => _onTap(i),
            items: [
              BottomNavigationBarItem(
                icon: Icon(Icons.tag_faces),
                title: Text("Мемы")
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.add_circle, size: 32,),
                title: Text("")
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.account_circle),
                title: Text("Аккаунт")
              ),
            ],
          ),
        );  
      },
    );
  }
}