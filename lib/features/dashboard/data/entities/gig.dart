import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'gig.freezed.dart';
part 'gig.g.dart';

enum GigStatus { pending, confirmed }

@freezed
class Gig with _$Gig {
  const factory Gig({
    required String id,
    required String venueId,
    @TimestampConverter() required DateTime date,
    required String loadInTime,
    required String setTimes,
    required double baseGuarantee,
    required bool is7030Split,
    required List<String> targetGenres,
    required String venueNotes,
    required GigStatus status,
    @Default(0) int pendingCount,
    String? confirmedPerformerName,
    String? confirmedPerformerAvatarUrl,
  }) = _Gig;

  factory Gig.fromJson(Map<String, dynamic> json) => _$GigFromJson(json);
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
