import 'package:equatable/equatable.dart';

abstract class PerformerEvent extends Equatable {
  const PerformerEvent();

  @override
  List<Object?> get props => [];
}

class LoadGigRequested extends PerformerEvent {
  final String gigId;

  const LoadGigRequested(this.gigId);

  @override
  List<Object?> get props => [gigId];
}

class SubmitApplicationRequested extends PerformerEvent {
  final String gigId;
  final String venueName;
  final String performerName;
  final String performerLink;

  const SubmitApplicationRequested({
    required this.gigId,
    required this.venueName,
    required this.performerName,
    required this.performerLink,
  });

  @override
  List<Object?> get props => [gigId, venueName, performerName, performerLink];
}
