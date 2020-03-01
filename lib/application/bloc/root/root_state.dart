import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class RootState extends Equatable {

  final bool isAuthenticated;

  const RootState({@required this.isAuthenticated});

  @override
  List<Object> get props => [isAuthenticated];

}