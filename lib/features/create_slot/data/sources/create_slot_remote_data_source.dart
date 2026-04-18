import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';
import '../create_slot_request.dart';

abstract class CreateSlotRemoteDataSource {
  Future<void> createSlot(CreateSlotRequest request);
}

@LazySingleton(as: CreateSlotRemoteDataSource)
class CreateSlotRemoteDataSourceImpl implements CreateSlotRemoteDataSource {
  final FirebaseFirestore _firestore;

  CreateSlotRemoteDataSourceImpl(this._firestore);

  @override
  Future<void> createSlot(CreateSlotRequest request) async {
    await _firestore.collection('slots').add(request.toJson());
  }
}
