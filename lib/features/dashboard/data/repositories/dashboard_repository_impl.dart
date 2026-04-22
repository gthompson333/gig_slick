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
}
