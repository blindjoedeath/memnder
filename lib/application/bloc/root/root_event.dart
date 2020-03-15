import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

abstract class RootEvent extends Equatable {
  const RootEvent();

  @override
  List<Object> get props => [];

}