import '../create_gig_request.dart';

abstract class CreateGigRepository {
  Future<void> createGig(CreateGigRequest request);
  Future<void> updateGig(String gigId, CreateGigRequest request);
}
