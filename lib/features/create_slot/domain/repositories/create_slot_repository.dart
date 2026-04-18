import '../entities/create_slot_request.dart';

abstract class CreateSlotRepository {
  Future<void> createSlot(CreateSlotRequest request);
}
