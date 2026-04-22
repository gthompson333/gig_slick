import 'package:injectable/injectable.dart';
import '../create_gig_request.dart';
import 'create_gig_repository.dart';
import '../sources/create_gig_remote_data_source.dart';

@LazySingleton(as: CreateGigRepository)
class CreateGigRepositoryImpl implements CreateGigRepository {
  final CreateGigRemoteDataSource remoteDataSource;

  CreateGigRepositoryImpl(this.remoteDataSource);

  @override
  Future<void> createGig(CreateGigRequest request) async {
    return await remoteDataSource.createGig(request);
  }

  @override
  Future<void> updateGig(String gigId, CreateGigRequest request) async {
    return await remoteDataSource.updateGig(gigId, request);
  }
}
