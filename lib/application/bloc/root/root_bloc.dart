import 'package:flutter/material.dart';
import 'package:memnder/application/service/authentication_service.dart';

import 'root_event.dart';
import 'root_state.dart';
import 'package:bloc/bloc.dart';

class RootBloc extends Bloc<RootEvent, RootState>{

  AuthenticationServiceInterface authenticationService;

  RootBloc(
    {
      @required this.authenticationService
    }
  );

  RootState get initialState{
    print(authenticationService.isAuthenticated);
    return RootState(
      isAuthenticated: authenticationService.isAuthenticated
    );
  }

  @override
  Stream<RootState> mapEventToState(RootEvent event) async* {
  }

}
			