import 'package:equatable/equatable.dart';
import 'package:memnder/application/model/meme_model.dart';
import 'package:meta/meta.dart';

abstract class MemesState extends Equatable {
  const MemesState();

  @override
  List<Object> get props => [];
}

class Initial extends MemesState{}

class Unauthenticated extends MemesState{}

class Loading extends MemesState{}

class ShowMeme extends MemesState{
  final MemeModel meme;

  const ShowMeme({@required this.meme});
}

class ShowError extends MemesState{
  final String message;

  const ShowError({@required this.message});
}

class ShowAlert extends MemesState{
  final String message;

  const ShowAlert({@required this.message});
}

class MemesEnded extends MemesState{}