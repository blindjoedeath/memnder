import 'package:flutter/material.dart';
import 'package:memnder/application/model/meme_model.dart';
import 'package:memnder/application/model/service_response.dart';
import 'package:memnder/application/service/authentication_service.dart';
import 'package:memnder/application/service/meme_service.dart';

import 'account_event.dart';
import 'account_state.dart';
import 'package:bloc/bloc.dart';

class AccountBloc extends Bloc<AccountEvent, AccountState>{


  final AuthenticationServiceInterface authenticationService;
  final MemeServiceInterface memeService;

  AccountBloc({
    @required this.authenticationService,
    @required this.memeService}){
  }

  @override
  Future<void> close() {
    return super.close();
  }

  void logout(){
    authenticationService.logout();
  }
  
  void _getMemes()async{
    var response = await memeService.getUserMemes();
    if (response is Success<List<MemeModel>>){
      add(LoadingSuccess(
        memes: response.value
      ));
    } else if (response is Error){
      add(LoadingError(
        message: response.message
      ));
    }
  }

  void _moreMemes()async{
    var response = await memeService.nextMemes();
    if (response is Success<List<MemeModel>>){
      add(LoadingMoreSuccess(
        memes: response.value
      ));
    } else if (response is Error){
      add(LoadingError(
        message: response.message
      ));
    }
  }

  AccountState get initialState => Initial();

  @override
  Stream<AccountState> mapEventToState(AccountEvent event) async* {
    if (event is Logout){
      yield* _mapLogout(event);
    } else if (event is MemesRequested){
      yield* _mapMemesRequested(event);
    } else if (event is LoadingError){
      yield* _mapLoadingError(event);
    } else if (event is LoadingSuccess){
      yield* _mapLoadingSuccess(event);
    } else if (event is AlertShown){
      yield* _mapAlertShown(event);
    } else if (event is MoreMemesRequested){
      yield* _mapMoreRequested(event);
    } else if (event is LoadingMoreSuccess){
      yield* _mapMoreLoadedMemes(event);
    }
  }

  Stream<AccountState> _mapMoreLoadedMemes(LoadingMoreSuccess event) async* {
    yield MoreLoadedMemes(
      memes: event.memes
    );
  }

  Stream<AccountState> _mapMoreRequested(MoreMemesRequested event) async* {
    _moreMemes();
  }

  Stream<AccountState> _mapAlertShown(AlertShown event) async* {
    yield Initial();
  }

  Stream<AccountState> _mapLoadingError(LoadingError event) async* {
    yield ErrorAlert(
      message: event.message
    );
  }

  Stream<AccountState> _mapLoadingSuccess(LoadingSuccess event) async* {
    yield LoadedMemes(
      memes: event.memes
    );
  }

  Stream<AccountState> _mapMemesRequested(MemesRequested event) async* {
    yield Loading();
    _getMemes();
  }

  Stream<AccountState> _mapLogout(Logout event) async* {
    logout();
  }

}
			