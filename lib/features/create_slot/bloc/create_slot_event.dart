import 'package:freezed_annotation/freezed_annotation.dart';

part 'create_slot_event.freezed.dart';

@freezed
class CreateSlotEvent with _$CreateSlotEvent {
  const factory CreateSlotEvent.started() = Started;
  const factory CreateSlotEvent.guaranteeChanged(double amount) = GuaranteeChanged;
  const factory CreateSlotEvent.splitToggled(bool is7030) = SplitToggled;
  const factory CreateSlotEvent.genreToggled(String genre) = GenreToggled;
  const factory CreateSlotEvent.dateChanged(DateTime date) = DateChanged;
  const factory CreateSlotEvent.loadInTimeChanged(String time) = LoadInTimeChanged;
  const factory CreateSlotEvent.setTimesChanged(String times) = SetTimesChanged;
  const factory CreateSlotEvent.venueNotesChanged(String notes) = VenueNotesChanged;
  const factory CreateSlotEvent.submitRequested() = SubmitRequested;
}
