import 'package:freezed_annotation/freezed_annotation.dart';

part 'create_slot_event.freezed.dart';

@freezed
class CreateSlotEvent with _$CreateSlotEvent {
  const factory CreateSlotEvent.started() = Started;
  const factory CreateSlotEvent.guaranteeChanged(double amount) = GuaranteeChanged;
  const factory CreateSlotEvent.splitToggled(bool is7030) = SplitToggled;
  const factory CreateSlotEvent.genreToggled(String genre) = GenreToggled;
  const factory CreateSlotEvent.submitRequested() = SubmitRequested;
}
