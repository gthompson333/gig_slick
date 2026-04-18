import 'package:injectable/injectable.dart';

import '../entities/slot.dart';
import 'dashboard_repository.dart';
import '../sources/dashboard_remote_data_source.dart';

@LazySingleton(as: DashboardRepository)
class DashboardRepositoryImpl implements DashboardRepository {
  final DashboardRemoteDataSource _remoteDataSource;

  DashboardRepositoryImpl(this._remoteDataSource);

  @override
  Stream<List<Slot>> getScheduledSlotsStream() {
    return _remoteDataSource.getScheduledSlotsStream();
  }

  @override
  Future<String> getMagicLinkUrl() {
    return _remoteDataSource.getMagicLinkUrl();
  }
}
