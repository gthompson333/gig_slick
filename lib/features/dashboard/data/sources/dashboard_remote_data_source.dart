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
  Future<void> updateGigDetails({
    required String gigId,
    required String loadInTime,
    required String setTime,
    required double baseGuarantee,
    required List<String> genres,
    required String venueNotes,
  });
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

    try {
      // 1. Find the venues owned by the user
      final venueQuery = await _firestore
          .collection('venues')
          .where('ownerId', isEqualTo: userId)
          .get();

      final batch = _firestore.batch();

      for (final venueDoc in venueQuery.docs) {
        final venueId = venueDoc.id;

        // 2. Find all gigs for this venue
        final gigsQuery = await _firestore
            .collection('gigs')
            .where('venueId', isEqualTo: venueId)
            .get();

        for (final gigDoc in gigsQuery.docs) {
          final gigId = gigDoc.id;

          // 3. Find and delete all applications for this gig
          final appsQuery = await _firestore
              .collection('gigs')
              .doc(gigId)
              .collection('applications')
              .get();

          for (final appDoc in appsQuery.docs) {
            batch.delete(appDoc.reference);
          }

          // 4. Delete the gig document
          batch.delete(gigDoc.reference);
        }

        // 5. Delete the venue document
        batch.delete(venueDoc.reference);
      }

      // Commit Firestore deletions
      await batch.commit();

      // 6. Delete the Firebase Auth user
      await user.delete();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'requires-recent-login') {
        throw Exception(
            'Account deletion requires recent login. Please sign out and sign in again before deleting your account.');
      }
      throw Exception('Failed to delete account: ${e.message}');
    } catch (e) {
      throw Exception('Failed to delete account data: $e');
    }
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

  @override
  Future<void> updateGigDetails({
    required String gigId,
    required String loadInTime,
    required String setTime,
    required double baseGuarantee,
    required List<String> genres,
    required String venueNotes,
  }) async {
    await _firestore.collection('gigs').doc(gigId).update({
      'loadInTime': loadInTime,
      'setTime': setTime,
      'baseGuarantee': baseGuarantee,
      'genres': genres,
      'venueNotes': venueNotes,
    });
  }
}
