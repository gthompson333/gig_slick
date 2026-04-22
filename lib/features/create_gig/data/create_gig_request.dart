class CreateGigRequest {
  final String venueId;
  final DateTime date;
  final double baseGuarantee;
  final bool is7030Split;
  final List<String> genres;
  final String loadInTime;
  final String setTime;
  final String venueNotes;

  final String status;

  CreateGigRequest({
    required this.venueId,
    required this.date,
    required this.baseGuarantee,
    required this.is7030Split,
    required this.genres,
    required this.loadInTime,
    required this.setTime,
    required this.venueNotes,
    this.status = 'draft',
  });

  Map<String, dynamic> toJson() {
    return {
      'venueId': venueId,
      'date': date,
      'baseGuarantee': baseGuarantee,
      'is7030Split': is7030Split,
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
      'is7030Split': is7030Split,
      'genres': genres,
      'loadInTime': loadInTime,
      'setTime': setTime,
      'venueNotes': venueNotes,
      'status': status,
    };
  }
}
