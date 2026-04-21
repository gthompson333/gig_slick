import 'package:freezed_annotation/freezed_annotation.dart';

part 'gig_details_event.freezed.dart';

@freezed
class GigDetailsEvent with _$GigDetailsEvent {
  const factory GigDetailsEvent.deleteRequested(String gigId) = DeleteRequested;
}
