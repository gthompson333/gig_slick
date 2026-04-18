import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/constants/constants.dart';
import '../entities/slot.dart';

abstract class DashboardRemoteDataSource {
  Stream<List<Slot>> getScheduledSlotsStream();
  Future<String> getMagicLinkUrl();
}

@LazySingleton(as: DashboardRemoteDataSource)
class DashboardRemoteDataSourceImpl implements DashboardRemoteDataSource {
  final FirebaseFirestore _firestore;

  DashboardRemoteDataSourceImpl(this._firestore);

  @override
  Stream<List<Slot>> getScheduledSlotsStream() {
    return _firestore
        .collection('slots')
        .where('venueId', isEqualTo: AppConstants.kDefaultVenueId)
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
