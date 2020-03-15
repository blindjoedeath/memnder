import 'load_meme_event.dart';
import 'load_meme_state.dart';
import 'package:bloc/bloc.dart';

class LoadMemeBloc extends Bloc<LoadMemeEvent, LoadMemeState>{

  LoadMemeState get initialState => null;

  @override
  Stream<LoadMemeState> mapEventToState(LoadMemeEvent event) async* {
  }

}
			