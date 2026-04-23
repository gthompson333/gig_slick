import 'package:injectable/injectable.dart';

import '../entities/gig.dart';
import 'dashboard_repository.dart';
import '../sources/dashboard_remote_data_source.dart';

@LazySingleton(as: DashboardRepository)
class DashboardRepositoryImpl implements DashboardRepository {
  final DashboardRemoteDataSource _remoteDataSource;

  DashboardRepositoryImpl(this._remoteDataSource);

  @override
  Future<Map<String, dynamic>?> getVenueForUser() {
    return _remoteDataSource.getVenueForUser();
  }

  @override
  Stream<List<Gig>> getScheduledGigsStream(String venueId) {
    return _remoteDataSource.getScheduledGigsStream(venueId);
  }

  @override
  Future<String> getGigLinkUrl() {
    return _remoteDataSource.getGigLinkUrl();
  }

  @override
  Future<void> deleteGig(String gigId) {
    return _remoteDataSource.deleteGig(gigId);
  }

  @override
  Future<void> deleteAccount() {
    return _remoteDataSource.deleteAccount();
  }

  @override
  Future<void> publishGig(String gigId) {
    return _remoteDataSource.publishGig(gigId);
  }

  @override
  Future<void> updateVenueNotes(String gigId, String notes) {
    return _remoteDataSource.updateVenueNotes(gigId, notes);
  }

  @override
  Future<void> updateGigDetails({
    required String gigId,
    required String loadInTime,
    required String setTime,
    required double baseGuarantee,
    required List<String> genres,
    required String venueNotes,
  }) {
    return _remoteDataSource.updateGigDetails(
      gigId: gigId,
      loadInTime: loadInTime,
      setTime: setTime,
      baseGuarantee: baseGuarantee,
      genres: genres,
      venueNotes: venueNotes,
    );
  }
}
