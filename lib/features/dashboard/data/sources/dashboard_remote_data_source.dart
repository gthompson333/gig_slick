import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';

import '../entities/gig.dart';

abstract class DashboardRemoteDataSource {
  Stream<List<Gig>> getScheduledGigsStream(String venueId);
  Future<Map<String, dynamic>?> getVenueForUser();
  Future<String> getGigLinkUrl();
  Future<void> deleteGig(String gigId);
  Future<void> deleteAccount();
  Future<void> publishGig(String gigId);
  Future<void> updateVenueNotes(String gigId, String notes);
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
    final doc = query.docs.first;
    return {...doc.data(), 'id': doc.id};
  }

  @override
  Stream<List<Gig>> getScheduledGigsStream(String venueId) {
    return _firestore
        .collection('gigs')
        .where('venueId', isEqualTo: venueId)
        .orderBy('date', descending: false)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            final data = doc.data();
            return Gig.fromJson({...data, 'id': doc.id});
          }).toList();
        });
  }

  @override
  Future<String> getGigLinkUrl() async {
    // Delay to simulate network request
    await Future.delayed(const Duration(milliseconds: 500));
    return 'gigslick.link/commonwealth';
  }

  @override
  Future<void> deleteGig(String gigId) async {
    await _firestore.collection('gigs').doc(gigId).delete();
  }

  @override
  Future<void> deleteAccount() async {
    final user = _auth.currentUser;
    if (user == null) return;

    final userId = user.uid;

    // 1. Find the venue owned by the user
    final venueQuery = await _firestore
        .collection('venues')
        .where('ownerId', isEqualTo: userId)
        .get();

    final batch = _firestore.batch();

    for (final venueDoc in venueQuery.docs) {
      final venueId = venueDoc.id;

      // 2. Find and delete all gigs for this venue
      final gigsQuery = await _firestore
          .collection('gigs')
          .where('venueId', isEqualTo: venueId)
          .get();

      for (final gigDoc in gigsQuery.docs) {
        batch.delete(gigDoc.reference);
      }

      // 3. Delete the venue document
      batch.delete(venueDoc.reference);
    }

    // Commit Firestore deletions
    await batch.commit();

    // 4. Delete the Firebase Auth user
    await user.delete();
  }

  @override
  Future<void> publishGig(String gigId) async {
    await _firestore.collection('gigs').doc(gigId).update({
      'status': 'live',
    });
  }

  @override
  Future<void> updateVenueNotes(String gigId, String notes) async {
    await _firestore.collection('gigs').doc(gigId).update({
      'venueNotes': notes,
    });
  }
}
