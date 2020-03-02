import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:memnder/application/bloc/account/account_event.dart';
import 'package:memnder/application/bloc/account/account_state.dart';
import 'package:memnder/application/bloc/memes/memes_event.dart';
import 'package:memnder/application/bloc/memes/memes_state.dart';
import 'package:memnder/application/entity/lazy.dart';
import 'package:memnder/application/bloc/authentication/authentication_bloc.dart';
import 'package:memnder/application/bloc/authentication/authentication_event.dart';
import 'package:memnder/application/bloc/authentication/authentication_state.dart';
import 'package:memnder/application/bloc/registration/registration_bloc.dart';
import 'package:memnder/application/bloc/root/root_event.dart';
import 'package:memnder/application/bloc/root/root_state.dart';
import 'package:memnder/application/manager/route_manager.dart';
import 'package:memnder/application/model/jwt_credentials.dart';
import 'package:memnder/application/provider/secure_storage_provider.dart';
import 'package:memnder/application/view/account/account_view.dart';
import 'package:memnder/application/view/authentication/authentication_view.dart';
import 'package:memnder/application/view/memes/memes_view.dart';
import 'package:memnder/application/view/registration/registration_view.dart';

class RootView extends StatefulWidget{ 
  final Lazy<Bloc<AuthenticationEvent, AuthenticationState>> authenticationBloc;
  final Lazy<Bloc<MemesEvent, MemesState>> memesBloc;
  final Lazy<Bloc<AccountEvent, AccountState>> accountBloc;

  final  Bloc<RootEvent, RootState> bloc;

  const RootView(
    {
      @required this.bloc,
      @required this.authenticationBloc,
      @required this.memesBloc,
      @required this.accountBloc
    }
  );

  @override
  State<StatefulWidget> createState() => _RootViewState();

}

class _RootViewState extends State<RootView>{

  int index = 0;
  bool isAuthenticated;

  Widget _buildFirstTab(){
    if (isAuthenticated){
      return AccountView(
        bloc: widget.accountBloc.instance
      );
    } else{
      return AuthenticationView(
        bloc: widget.authenticationBloc.instance,
      );
    }
  }

  Future<Widget> _buildSecondTab()async{
    await RouteManager.prepareNamed("/memes");
    return MemesView(
      bloc: widget.memesBloc.instance
    );
  }

  @override
  void initState(){
    super.initState();

    isAuthenticated = widget.bloc.initialState.isAuthenticated;
    _onTap(index);

  }

  Widget _currentBody;

  void _onTap(int i)async{
    index = i;
    if (index == 0){
      _currentBody = _buildFirstTab();
    } else {
      _currentBody = await _buildSecondTab();
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<Bloc<RootEvent, RootState>, RootState>(
      bloc: widget.bloc,
      builder: (context, state){
        if (isAuthenticated != state.isAuthenticated){
          isAuthenticated = state.isAuthenticated;
          WidgetsBinding.instance.addPostFrameCallback((d){
            _onTap(index);
          });
        }
        isAuthenticated = state.isAuthenticated;
        return Scaffold(
          body: _currentBody,
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: index,
            onTap: (i) => _onTap(i),
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
      },
    );
  }
}