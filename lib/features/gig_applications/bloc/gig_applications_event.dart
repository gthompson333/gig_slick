import 'package:freezed_annotation/freezed_annotation.dart';

part 'gig_applications_event.freezed.dart';

@freezed
class GigApplicationsEvent with _$GigApplicationsEvent {
  const factory GigApplicationsEvent.confirmApplicationRequested({
    required String gigId,
    required String applicationId,
    required String performerName,
  }) = ConfirmApplicationRequested;
}
