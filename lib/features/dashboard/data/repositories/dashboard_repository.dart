import '../entities/slot.dart';

abstract class DashboardRepository {
  Stream<List<Slot>> getScheduledSlotsStream(String venueId);
  Future<Map<String, dynamic>?> getVenueForUser();
  Future<String> getMagicLinkUrl();
}
