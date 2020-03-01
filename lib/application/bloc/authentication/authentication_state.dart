import 'package:equatable/equatable.dart';
import 'package:memnder/application/validator/authentication_validator.dart';
import 'package:meta/meta.dart';

class AuthenticationState extends Equatable {
  const AuthenticationState();

  @override
  List<Object> get props => [];

}
			
class AuthenticationValidationError extends AuthenticationState{
  final String errorMessage;
  final AuthenticationField field;

  const AuthenticationValidationError(
    {
      @required this.errorMessage,
      @required this.field
    }
  );

  @override
  List<Object> get props => [errorMessage, field];
}

class AuthenticationLoading extends AuthenticationState{}

class AuthenticationSuccess extends AuthenticationState{}

class AuthenticationError extends AuthenticationState{
  final String message;

  const AuthenticationError(
    {
      this.message
    }
  );
}