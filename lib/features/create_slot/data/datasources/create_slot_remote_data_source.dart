import 'package:injectable/injectable.dart';
import '../../domain/entities/create_slot_request.dart';

abstract class CreateSlotRemoteDataSource {
  Future<void> createSlot(CreateSlotRequest request);
}

@LazySingleton(as: CreateSlotRemoteDataSource)
class CreateSlotRemoteDataSourceImpl implements CreateSlotRemoteDataSource {
  @override
  Future<void> createSlot(CreateSlotRequest request) async {
    // Delay to simulate network request
    await Future.delayed(const Duration(seconds: 1));
    return;
  }
}
