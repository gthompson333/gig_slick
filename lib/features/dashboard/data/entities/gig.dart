import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'gig.freezed.dart';
part 'gig.g.dart';

enum GigStatus { draft, live, pending, confirmed }

@freezed
class Gig with _$Gig {
  const factory Gig({
    required String id,
    required String gigId,
    required String venueId,
    @TimestampConverter() required DateTime date,
    required String loadInTime,
    required String setTime,
    required double baseGuarantee,
    required List<String> genres,
    required String venueNotes,
    required GigStatus status,
    @Default(0) int applicantCount,
    String? confirmedPerformerName,
    String? confirmedPerformerAvatarUrl,
    String? appliedPerformerName,
    String? appliedPerformerLink,
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
