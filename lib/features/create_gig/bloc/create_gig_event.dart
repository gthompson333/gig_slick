import 'package:freezed_annotation/freezed_annotation.dart';
import '../../dashboard/data/entities/gig.dart';

part 'create_gig_event.freezed.dart';

@freezed
class CreateGigEvent with _$CreateGigEvent {
  const factory CreateGigEvent.started(String venueId, {Gig? initialGig}) =
      Started;
  const factory CreateGigEvent.guaranteeChanged(double amount) =
      GuaranteeChanged;
  const factory CreateGigEvent.splitToggled(bool is7030) = SplitToggled;
  const factory CreateGigEvent.genreToggled(String genre) = GenreToggled;
  const factory CreateGigEvent.dateChanged(DateTime date) = DateChanged;
  const factory CreateGigEvent.loadInTimeChanged(String time) =
      LoadInTimeChanged;
  const factory CreateGigEvent.setTimeChanged(String time) = SetTimeChanged;
  const factory CreateGigEvent.venueNotesChanged(String notes) =
      VenueNotesChanged;
  const factory CreateGigEvent.submitRequested() = SubmitRequested;
}
