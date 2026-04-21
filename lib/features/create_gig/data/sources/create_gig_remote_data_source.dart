import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';
import '../create_gig_request.dart';

abstract class CreateGigRemoteDataSource {
  Future<void> createGig(CreateGigRequest request);
}

@LazySingleton(as: CreateGigRemoteDataSource)
class CreateGigRemoteDataSourceImpl implements CreateGigRemoteDataSource {
  final FirebaseFirestore _firestore;

  CreateGigRemoteDataSourceImpl(this._firestore);

  @override
  Future<void> createGig(CreateGigRequest request) async {
    await _firestore.collection('gigs').add(request.toJson());
  }
}
