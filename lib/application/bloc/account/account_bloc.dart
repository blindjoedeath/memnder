import 'package:flutter/material.dart';
import 'package:memnder/application/service/authentication_service.dart';

import 'account_event.dart';
import 'account_state.dart';
import 'package:bloc/bloc.dart';

class AccountBloc extends Bloc<AccountEvent, AccountState>{


  final AuthenticationServiceInterface authenticationService;

  AccountBloc({@required this.authenticationService});

  void logout(){
    authenticationService.logout();
  }

  AccountState get initialState => null;

  @override
  Stream<AccountState> mapEventToState(AccountEvent event) async* {
    if (event is Logout){
      yield* _mapLogout(event);
    }
  }

  Stream<AccountState> _mapLogout(Logout event) async* {
    logout();
  }

}
			