import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';

import '../../dashboard/data/entities/gig.dart';

abstract class PerformerRepository {
  Future<Gig?> getGig(String gigId);
  Future<String?> getVenueName(String venueId);
  Future<void> applyForGig({
    required String gigId,
    required String venueName,
    required String performerName,
    required String performerEmail,
    required String performerLink,
  });
  Future<List<Gig>> getLiveGigs(String venueId);
}

@LazySingleton(as: PerformerRepository)
class PerformerRepositoryImpl implements PerformerRepository {
  final FirebaseFirestore _firestore;

  PerformerRepositoryImpl(this._firestore);

  @override
  Future<Gig?> getGig(String gigId) async {
    // Try fetching by document ID first (for newly created gigs)
    final doc = await _firestore.collection('gigs').doc(gigId).get();
    if (doc.exists) {
      return Gig.fromJson({...doc.data()!, 'id': doc.id});
    }

    // Fallback for older gigs where the document ID did not match the gigId field
    final query = await _firestore
        .collection('gigs')
        .where('gigId', isEqualTo: gigId)
        .limit(1)
        .get();

    if (query.docs.isNotEmpty) {
      final queryDoc = query.docs.first;
      return Gig.fromJson({...queryDoc.data(), 'id': queryDoc.id});
    }

    return null;
  }

  @override
  Future<String?> getVenueName(String venueId) async {
    final doc = await _firestore.collection('venues').doc(venueId).get();
    return doc.data()?['name'] as String?;
  }

  @override
  Future<void> applyForGig({
    required String gigId,
    required String venueName,
    required String performerName,
    required String performerEmail,
    required String performerLink,
  }) async {
    final batch = _firestore.batch();

    // 1. Create a new document in the gig's applications sub-collection
    final applicationRef = _firestore
        .collection('gigs')
        .doc(gigId)
        .collection('applications')
        .doc();

    batch.set(applicationRef, {
      'performerName': performerName,
      'performerEmail': performerEmail,
      'performerLink': performerLink,
      'appliedAt': FieldValue.serverTimestamp(),
      'status': 'pending',
    });

    // 2. Update the existing Gig document
    final gigRef = _firestore.collection('gigs').doc(gigId);
    batch.update(gigRef, {
      'status': 'pending',
      'applicantCount': FieldValue.increment(1),
    });

    await batch.commit();
  }

  @override
  Future<List<Gig>> getLiveGigs(String venueId) async {
    final query = await _firestore
        .collection('gigs')
        .where('venueId', isEqualTo: venueId)
        .where('status', isEqualTo: 'live')
        .orderBy('date', descending: false)
        .get();

    return query.docs
        .map((doc) => Gig.fromJson({...doc.data(), 'id': doc.id}))
        .toList();
  }
}
