import 'package:freezed_annotation/freezed_annotation.dart';

part 'slot.freezed.dart';
part 'slot.g.dart';

enum SlotStatus {
  pending,
  confirmed,
}

@freezed
class Slot with _$Slot {
  const factory Slot({
    required String id,
    required DateTime date,
    required DateTime startTime,
    required DateTime endTime,
    required SlotStatus status,
    @Default(0) int pendingCount,
    String? confirmedPerformerName,
    String? confirmedPerformerAvatarUrl,
  }) = _Slot;

  factory Slot.fromJson(Map<String, dynamic> json) => _$SlotFromJson(json);
}
