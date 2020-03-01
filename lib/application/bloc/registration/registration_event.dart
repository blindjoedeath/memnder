import 'package:equatable/equatable.dart';
import 'package:memnder/application/view_model/registration_view_model.dart';
import 'package:meta/meta.dart';

abstract class RegistrationEvent extends Equatable {
  const RegistrationEvent();

  @override
  List<Object> get props => [];

}


class RegistrationAttempt extends RegistrationEvent{
  final RegistrationViewModel registration;

  const RegistrationAttempt({@required this.registration});

  @override
  List<Object> get props => [registration];

}