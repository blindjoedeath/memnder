import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

abstract class AppEvent extends Equatable {
  const AppEvent();

  @override
  List<Object> get props => [];

}

class AuthenticationChanged extends AppEvent{
  final bool state;

  const AuthenticationChanged(
    {
      @required this.state
    }
  );

  @override
  List<Object> get props => [state];
}
			