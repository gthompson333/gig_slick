import '../entities/gig.dart';

abstract class DashboardRepository {
  Stream<List<Gig>> getScheduledGigsStream(String venueId);
  Future<Map<String, dynamic>?> getVenueForUser();
  Future<String> getGigLinkUrl();
  Future<void> deleteGig(String gigId);
  Future<void> deleteAccount();
  Future<void> publishGig(String gigId);
  Future<void> updateVenueNotes(String gigId, String notes);
  Future<void> updateGigDetails({
    required String gigId,
    required String loadInTime,
    required String setTime,
    required double baseGuarantee,
    required List<String> genres,
    required String venueNotes,
  });
}
