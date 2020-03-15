import 'package:flutter/material.dart';
import 'package:memnder/application/service/authentication_service.dart';

import 'app_event.dart';
import 'app_state.dart';
import 'package:bloc/bloc.dart';

class AppBloc extends Bloc<AppEvent, AppState>{

  AuthenticationServiceInterface authenticationService;

  AppState get initialState => AppState(
    isAuthenticated: authenticationService.isAuthenticated
  );

  void authenticationListener(){
    if (state.isAuthenticated != authenticationService.isAuthenticated){
      add(AuthenticationChanged(
        state: authenticationService.isAuthenticated
      ));
    }
  }

  AppBloc({@required this.authenticationService}){
    this.authenticationService = authenticationService;
    authenticationService.addListener(authenticationListener);
  }

  @override
  Future<void> close() {
    authenticationService.removeListener(authenticationListener);
    return super.close();
  }

  @override
  Stream<AppState> mapEventToState(AppEvent event) async* {
    if (event is AuthenticationChanged){
      yield* _mapAuthenticationChanged(event);
    }
  }

  Stream<AppState> _mapAuthenticationChanged(AuthenticationChanged event)async*{
    yield AppState(
      isAuthenticated: event.state
    );
  }

}
			