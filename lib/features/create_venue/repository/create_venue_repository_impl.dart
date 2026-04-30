import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';
import 'create_venue_repository.dart';

@Injectable(as: CreateVenueRepository)
class CreateVenueRepositoryImpl implements CreateVenueRepository {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  CreateVenueRepositoryImpl(this._firestore, this._auth);

  @override
  Future<void> createVenue({
    required String name,
  }) async {
    final user = _auth.currentUser;
    if (user == null) {
      throw Exception('User must be signed in to create a venue.');
    }

    try {
      await _firestore.collection('venues').add({
        'name': name,
        'nameLowercase': name.toLowerCase(),
        'ownerId': user.uid,
        'createdAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Failed to create venue: $e');
    }
  }

  @override
  Future<bool> isVenueNameAvailable(String name) async {
    try {
      final snapshot = await _firestore
          .collection('venues')
          .where('nameLowercase', isEqualTo: name.toLowerCase())
          .limit(1)
          .get();

      return snapshot.docs.isEmpty;
    } catch (e) {
      throw Exception('Failed to check name availability: $e');
    }
  }
}
