import '../entities/gig.dart';

abstract class DashboardRepository {
  Stream<List<Gig>> getScheduledGigsStream(String venueId);
  Future<Map<String, dynamic>?> getVenueForUser();
  Future<String> getGigLinkUrl();
  Future<void> deleteGig(String gigId);
  Future<void> deleteAccount();
  Future<void> publishGig(String gigId);
  Future<void> updateVenueNotes(String gigId, String notes);
}
