import 'package:equatable/equatable.dart';
import 'package:memnder/application/model/meme_model.dart';
import 'package:meta/meta.dart';

abstract class AccountState extends Equatable {
  const AccountState();

  @override
  List<Object> get props => [];

}

class Initial extends AccountState{}

class Loading extends AccountState{}

class ErrorAlert extends AccountState{
  final String message; 

  const ErrorAlert(
    {
      @required this.message
    }
  );
}

class LoadedMemes extends AccountState{
  final List<MemeModel> memes;

  const LoadedMemes(
    {
      this.memes
    }
  );
}

class MoreLoadedMemes extends AccountState{
  final List<MemeModel> memes;

  const MoreLoadedMemes(
    {
      this.memes
    }
  );
}
