import 'package:equatable/equatable.dart';
import 'package:memnder/application/entity/meme_reaction.dart';
import 'package:memnder/application/model/meme_model.dart';
import 'package:memnder/application/view/shared/swipeable/image_preloader.dart';
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

class AuthenticationChanged extends MemesEvent{
  final bool state;

  const AuthenticationChanged({@required this.state});
}

class MemesEndedEvent extends MemesEvent{}

class PrecachedImages extends MemesEvent{
  final List<PreloadedImage> preloaded;
  final MemeModel meme;

  const PrecachedImages({@required this.preloaded, @required this.meme});
}