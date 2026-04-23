import 'package:freezed_annotation/freezed_annotation.dart';

part 'create_gig_state.freezed.dart';

@freezed
class CreateGigState with _$CreateGigState {
  const factory CreateGigState({
    required String venueId,
    required double baseGuarantee,
    required List<String> selectedGenres,
    required bool isSubmitting,
    required bool isSuccess,
    required DateTime selectedDate,
    @Default('7:00 PM') String loadInTime,
    @Default('9:00 PM') String setTime,
    @Default('') String venueNotes,
    @Default('draft') String status,
    String? gigId,
    String? errorMessage,
  }) = _CreateGigState;

  factory CreateGigState.initial() => CreateGigState(
    venueId: '',
    baseGuarantee: 350.0,
    selectedGenres: ['Folk', 'Metal'],
    isSubmitting: false,
    isSuccess: false,
    selectedDate: DateTime.now(),
    loadInTime: '7:00 PM',
    setTime: '9:00 PM',
    venueNotes: '',
  );
}
