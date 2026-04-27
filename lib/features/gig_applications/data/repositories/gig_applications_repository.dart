import 'package:cloud_firestore/cloud_firestore.dart';

abstract class GigApplicationsRepository {
  Future<void> confirmApplication(String gigId, String applicationId, String performerName);
}

class GigApplicationsRepositoryImpl implements GigApplicationsRepository {
  final FirebaseFirestore _firestore;

  GigApplicationsRepositoryImpl(this._firestore);

  @override
  Future<void> confirmApplication(String gigId, String applicationId, String performerName) async {
    final batch = _firestore.batch();

    // 1. Update the gig
    final gigRef = _firestore.collection('gigs').doc(gigId);
    batch.update(gigRef, {
      'status': 'confirmed',
      'confirmedPerformerName': performerName,
    });

    // 2. Update the application
    final applicationRef = gigRef.collection('applications').doc(applicationId);
    batch.update(applicationRef, {
      'status': 'confirmed',
    });

    await batch.commit();
  }
}
