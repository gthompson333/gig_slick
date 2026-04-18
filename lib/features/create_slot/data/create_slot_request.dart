class CreateSlotRequest {
  final DateTime date;
  final double baseGuarantee;
  final bool is7030Split;
  final List<String> targetGenres;
  final String loadInTime;
  final String setTimes;
  final String venueNotes;

  CreateSlotRequest({
    required this.date,
    required this.baseGuarantee,
    required this.is7030Split,
    required this.targetGenres,
    required this.loadInTime,
    required this.setTimes,
    required this.venueNotes,
  });
}
