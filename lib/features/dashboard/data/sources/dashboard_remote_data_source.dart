import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';

import '../entities/slot.dart';

abstract class DashboardRemoteDataSource {
  Stream<List<Slot>> getScheduledSlotsStream(String venueId);
  Future<Map<String, dynamic>?> getVenueForUser();
  Future<String> getMagicLinkUrl();
}

@LazySingleton(as: DashboardRemoteDataSource)
class DashboardRemoteDataSourceImpl implements DashboardRemoteDataSource {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  DashboardRemoteDataSourceImpl(this._firestore, this._auth);

  @override
  Future<Map<String, dynamic>?> getVenueForUser() async {
    final user = _auth.currentUser;
    if (user == null) return null;

    final query = await _firestore
        .collection('venues')
        .where('ownerId', isEqualTo: user.uid)
        .limit(1)
        .get();

    if (query.docs.isEmpty) return null;
    return query.docs.first.data();
  }

  @override
  Stream<List<Slot>> getScheduledSlotsStream(String venueId) {
    return _firestore
        .collection('slots')
        .where('venueId', isEqualTo: venueId)
        .orderBy('date', descending: false)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        return Slot.fromJson({
          ...data,
          'id': doc.id,
        });
      }).toList();
    });
  }

  @override
  Future<String> getMagicLinkUrl() async {
    // Delay to simulate network request
    await Future.delayed(const Duration(milliseconds: 500));
    return 'stageslot.link/commonwealth';
  }
}
