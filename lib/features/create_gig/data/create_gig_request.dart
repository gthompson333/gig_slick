class CreateGigRequest {
  final String venueId;
  final String gigId;
  final DateTime date;
  final double baseGuarantee;
  final List<String> genres;
  final String loadInTime;
  final String setTime;
  final String venueNotes;

  final String status;

  CreateGigRequest({
    required this.venueId,
    required this.gigId,
    required this.date,
    required this.baseGuarantee,
    required this.genres,
    required this.loadInTime,
    required this.setTime,
    required this.venueNotes,
    this.status = 'draft',
  });

  Map<String, dynamic> toJson() {
    return {
      'venueId': venueId,
      'gigId': gigId,
      'date': date,
      'baseGuarantee': baseGuarantee,

      'genres': genres,
      'loadInTime': loadInTime,
      'setTime': setTime,
      'venueNotes': venueNotes,
      'createdAt': DateTime.now(),
      'status': status,
    };
  }

  Map<String, dynamic> toUpdateJson() {
    return {
      'date': date,
      'baseGuarantee': baseGuarantee,

      'genres': genres,
      'loadInTime': loadInTime,
      'setTime': setTime,
      'venueNotes': venueNotes,
      'status': status,
    };
  }
}
