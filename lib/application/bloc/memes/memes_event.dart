import 'package:equatable/equatable.dart';
import 'package:memnder/application/entity/meme_reaction.dart';
import 'package:memnder/application/model/meme_model.dart';
import 'package:meta/meta.dart';

abstract class MemesEvent extends Equatable {
  const MemesEvent();

  @override
  List<Object> get props => [];

}

class MemeRequested extends MemesEvent{}

class MemeReactionSet extends MemesEvent{
  final MemeReaction reaction;
  final MemeModel meme;

  const MemeReactionSet({@required this.reaction, @required this.meme});
}

class MemeLoaded extends MemesEvent{
  final MemeModel meme;

  const MemeLoaded({@required this.meme});
}

class MemeError extends MemesEvent{
  final String message;

  const MemeError({@required this.message});
}

class MemeAlert extends MemesEvent{
  final String message;

  const MemeAlert({@required this.message});
}