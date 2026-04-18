import 'package:cloud_firestore/cloud_firestore.dart';
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
    required String venueId,
    @TimestampConverter() required DateTime date,
    @TimestampConverter() required DateTime startTime,
    @TimestampConverter() required DateTime endTime,
    required SlotStatus status,
    @Default(0) int pendingCount,
    String? confirmedPerformerName,
    String? confirmedPerformerAvatarUrl,
  }) = _Slot;

  factory Slot.fromJson(Map<String, dynamic> json) => _$SlotFromJson(json);
}

class TimestampConverter implements JsonConverter<DateTime, dynamic> {
  const TimestampConverter();

  @override
  DateTime fromJson(dynamic json) {
    if (json is Timestamp) {
      return json.toDate();
    }
    if (json is String) {
      return DateTime.parse(json);
    }
    return DateTime.now(); // Fallback
  }

  @override
  dynamic toJson(DateTime object) => object.toIso8601String();
}

