import 'package:freezed_annotation/freezed_annotation.dart';

part 'create_slot_state.freezed.dart';

@freezed
class CreateSlotState with _$CreateSlotState {
  const factory CreateSlotState({
    required double baseGuarantee,
    required bool is7030Split,
    required List<String> selectedGenres,
    required bool isSubmitting,
    required bool isSuccess,
    DateTime? selectedDate,
    @Default('7:00 PM') String loadInTime,
    @Default('9:00 PM') String setTimes,
    @Default('') String venueNotes,
    String? errorMessage,
  }) = _CreateSlotState;

  factory CreateSlotState.initial() => const CreateSlotState(
        baseGuarantee: 350.0,
        is7030Split: true,
        selectedGenres: ['Folk', 'Metal'],
        isSubmitting: false,
        isSuccess: false,
        loadInTime: '7:00 PM',
        setTimes: '9:00 PM',
        venueNotes: '',
      );
}
