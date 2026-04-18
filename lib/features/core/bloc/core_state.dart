import 'package:equatable/equatable.dart';

abstract class CoreState extends Equatable {
  const CoreState();
  
  @override
  List<Object> get props => [];
}

class CoreInitial extends CoreState {}
class CoreLoading extends CoreState {}
class CoreLoaded extends CoreState {}
class CoreError extends CoreState {
  final String message;
  const CoreError(this.message);

  @override
  List<Object> get props => [message];
}
