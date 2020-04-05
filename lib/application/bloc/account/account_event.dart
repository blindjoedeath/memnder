import 'package:equatable/equatable.dart';
import 'package:memnder/application/model/meme_model.dart';
import 'package:meta/meta.dart';

abstract class AccountEvent extends Equatable {
  const AccountEvent();

  @override
  List<Object> get props => [];

}

class Logout extends AccountEvent{}

class MemesRequested extends AccountEvent{}

class AlertShown extends AccountEvent{}

class LoadingError extends AccountEvent{
  final String message;

  const LoadingError({
    this.message
  });
}

class LoadingSuccess extends AccountEvent{
  final List<MemeModel> memes;

  const LoadingSuccess({
    @required this.memes
  });
}

class LoadingMoreSuccess extends AccountEvent{
  final List<MemeModel> memes;

  const LoadingMoreSuccess({
    @required this.memes
  });
}

class MoreMemesRequested extends AccountEvent{}

class AccountClosed extends AccountEvent{}