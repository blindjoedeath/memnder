import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class LoadMemeState extends Equatable {
  const LoadMemeState();

  @override
  List<Object> get props => [];

}
			

class Sending extends LoadMemeState{}

class LoadSuccess extends LoadMemeState{}

class LoadError extends LoadMemeState{
  final String message;

  const LoadError({@required this.message});
}