import '../create_gig_request.dart';

abstract class CreateGigRepository {
  Future<void> createGig(CreateGigRequest request);
}
