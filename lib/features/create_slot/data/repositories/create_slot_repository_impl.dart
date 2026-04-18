import 'package:injectable/injectable.dart';
import '../create_slot_request.dart';
import 'create_slot_repository.dart';
import '../sources/create_slot_remote_data_source.dart';

@LazySingleton(as: CreateSlotRepository)
class CreateSlotRepositoryImpl implements CreateSlotRepository {
  final CreateSlotRemoteDataSource remoteDataSource;

  CreateSlotRepositoryImpl(this.remoteDataSource);

  @override
  Future<void> createSlot(CreateSlotRequest request) async {
    return await remoteDataSource.createSlot(request);
  }
}
