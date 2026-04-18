class CreateSlotRequest {
  final String venueId;
  final DateTime date;
  final double baseGuarantee;
  final bool is7030Split;
  final List<String> targetGenres;
  final String loadInTime;
  final String setTimes;
  final String venueNotes;

  CreateSlotRequest({
    required this.venueId,
    required this.date,
    required this.baseGuarantee,
    required this.is7030Split,
    required this.targetGenres,
    required this.loadInTime,
    required this.setTimes,
    required this.venueNotes,
  });

  Map<String, dynamic> toJson() {
    return {
      'venueId': venueId,
      'date': date,
      'baseGuarantee': baseGuarantee,
      'is7030Split': is7030Split,
      'targetGenres': targetGenres,
      'loadInTime': loadInTime,
      'setTimes': setTimes,
      'venueNotes': venueNotes,
      'createdAt': DateTime.now(),
      'status': 'pending', // Default status for new slots
    };
  }
}
