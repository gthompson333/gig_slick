import '../entities/slot.dart';

abstract class DashboardRepository {
  Future<List<Slot>> getScheduledSlots();
  Future<String> getMagicLinkUrl();
}
