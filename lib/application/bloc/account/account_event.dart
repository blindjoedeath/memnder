import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

abstract class AccountEvent extends Equatable {
  const AccountEvent();

  @override
  List<Object> get props => [];

}

class Logout extends AccountEvent{}
			