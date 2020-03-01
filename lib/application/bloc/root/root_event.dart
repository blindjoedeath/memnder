import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

abstract class RootEvent extends Equatable {
  const RootEvent();

  @override
  List<Object> get props => [];

}

class AuthenticationChanged extends RootEvent{
  final bool state;

  const AuthenticationChanged(
    {
      @required this.state
    }
  );

  @override
  List<Object> get props => [state];
}
			