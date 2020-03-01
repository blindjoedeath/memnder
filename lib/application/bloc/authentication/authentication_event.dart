import 'package:equatable/equatable.dart';
import 'package:memnder/application/view_model/authentication_view_model.dart';
import 'package:meta/meta.dart';

abstract class AuthenticationEvent extends Equatable {
  const AuthenticationEvent();

  @override
  List<Object> get props => [];

}


class AuthenticationAttempt extends AuthenticationEvent{
  final AuthenticationViewModel authentication;

  const AuthenticationAttempt({@required this.authentication});

  @override
  List<Object> get props => [authentication];

}

class Authenticated extends AuthenticationEvent{}

class ReceivedError extends AuthenticationEvent{
  final String message;

  ReceivedError(
    {
      @required this.message
    }
  );
}