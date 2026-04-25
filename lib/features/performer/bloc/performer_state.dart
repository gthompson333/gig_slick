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
  final String venueName;
  const PerformerLoaded(this.gig, this.venueName);

  @override
  List<Object?> get props => [gig, venueName];
}

class PerformerSubmitting extends PerformerState {
  final Gig gig;
  final String venueName;
  const PerformerSubmitting(this.gig, this.venueName);

  @override
  List<Object?> get props => [gig, venueName];
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
