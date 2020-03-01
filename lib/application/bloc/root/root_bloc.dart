import 'package:flutter/material.dart';
import 'package:memnder/application/service/authentication_service.dart';

import 'root_event.dart';
import 'root_state.dart';
import 'package:bloc/bloc.dart';

class RootBloc extends Bloc<RootEvent, RootState>{

  AuthenticationServiceInterface authenticationService;

  RootState get initialState => RootState(
    isAuthenticated: authenticationService.isAuthenticated
  );

  void authenticationListener(){
    if (state.isAuthenticated != authenticationService.isAuthenticated){
      add(AuthenticationChanged(
        state: authenticationService.isAuthenticated
      ));
    }
  }

  RootBloc({@required this.authenticationService}){
    this.authenticationService = authenticationService;
    authenticationService.addListener(authenticationListener);
  }

  @override
  Future<void> close() {
    authenticationService.removeListener(authenticationListener);
    return super.close();
  }

  @override
  Stream<RootState> mapEventToState(RootEvent event) async* {
    if (event is AuthenticationChanged){
      yield* _mapAuthenticationChanged(event);
    }
  }

  Stream<RootState> _mapAuthenticationChanged(AuthenticationChanged event)async*{
    yield RootState(
      isAuthenticated: event.state
    );
  }

}
			