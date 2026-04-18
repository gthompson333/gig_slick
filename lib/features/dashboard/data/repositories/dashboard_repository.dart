import '../entities/slot.dart';

abstract class DashboardRepository {
  Stream<List<Slot>> getScheduledSlotsStream();
  Future<String> getMagicLinkUrl();
}
