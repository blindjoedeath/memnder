import 'package:flutter/material.dart';
import 'package:memnder/application/model/service_response.dart';
import 'package:memnder/application/service/meme_service.dart';

import 'load_meme_event.dart';
import 'load_meme_state.dart';
import 'package:bloc/bloc.dart';

class LoadMemeBloc extends Bloc<LoadMemeEvent, LoadMemeState>{

  final MemeServiceInterface memeService;

  LoadMemeBloc(
    {
      @required this.memeService
    }
  );

  LoadMemeState get initialState => LoadMemeState();

  void sendImages(List<List<int>> images)async{
    var response = await memeService.upload(images);
    add(MemeSendingResult(result: response is Success));
  }

  @override
  Stream<LoadMemeState> mapEventToState(LoadMemeEvent event) async* {
    if (event is SendMeme){
      yield* _mapSendMeme(event);
    } else if (event is MemeSendingResult){
      yield* _mapMemeSendingResult(event);
    }
  }

  Stream<LoadMemeState> _mapMemeSendingResult(MemeSendingResult event) async*{
    yield event.result ? LoadSuccess() : LoadError(
      message: "Возникла неизвестная ошибка"
    );
  }

  Stream<LoadMemeState> _mapSendMeme(SendMeme event) async*{
    yield Sending();
    sendImages(event.images);
  }

}
			