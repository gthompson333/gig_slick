import 'package:equatable/equatable.dart';
import '../../dashboard/data/entities/gig.dart';

abstract class PerformerState extends Equatable {
  const PerformerState();

  @override
  List<Object?> get props => [];
}

class PerformerInitial extends PerformerState {
  const PerformerInitial();
}

class PerformerLoading extends PerformerState {
  const PerformerLoading();
}

class PerformerLoaded extends PerformerState {
  final Gig gig;
  const PerformerLoaded(this.gig);

  @override
  List<Object?> get props => [gig];
}

class PerformerSubmitting extends PerformerState {
  final Gig gig;
  const PerformerSubmitting(this.gig);

  @override
  List<Object?> get props => [gig];
}

class PerformerSubmittedSuccess extends PerformerState {
  const PerformerSubmittedSuccess();
}

class PerformerError extends PerformerState {
  final String message;
  const PerformerError(this.message);

  @override
  List<Object?> get props => [message];
}
