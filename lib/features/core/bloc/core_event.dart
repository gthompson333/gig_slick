import 'package:equatable/equatable.dart';

abstract class CoreEvent extends Equatable {
  const CoreEvent();

  @override
  List<Object> get props => [];
}

class CoreStarted extends CoreEvent {}
