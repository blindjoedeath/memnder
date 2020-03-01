import 'package:equatable/equatable.dart';
import 'package:memnder/application/validator/registration_validator.dart';
import 'package:meta/meta.dart';

class RegistrationState extends Equatable {
  const RegistrationState();

  @override
  List<Object> get props => [];

}
			
class RegistrationValidationError extends RegistrationState{
  final String errorMessage;
  final RegistrationField field;

  const RegistrationValidationError(
    {
      @required this.errorMessage,
      @required this.field
    }
  );

  @override
  List<Object> get props => [errorMessage, field];
}

class RegistrationLoading extends RegistrationState{}

class RegistrationSuccess extends RegistrationState{}

class RegistrationError extends RegistrationState{
  final String message;

  const RegistrationError(
    {
      this.message
    }
  );
}