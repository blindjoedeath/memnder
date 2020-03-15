import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

abstract class LoadMemeEvent extends Equatable {
  const LoadMemeEvent();

  @override
  List<Object> get props => [];

}

class SendMeme extends LoadMemeEvent{
  final List<List<int>> images;

  const SendMeme(
    {
      @required this.images
    }
  );

  @override
  List<Object> get props => [images];
}

class MemeSendingResult extends LoadMemeEvent{
  final bool result;

  const MemeSendingResult({@required this.result});
}