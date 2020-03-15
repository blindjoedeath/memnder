import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class AppState extends Equatable {

  final bool isAuthenticated;

  const AppState({@required this.isAuthenticated});

  @override
  List<Object> get props => [isAuthenticated];

}