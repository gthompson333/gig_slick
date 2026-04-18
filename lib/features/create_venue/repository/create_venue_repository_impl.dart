import 'package:injectable/injectable.dart';
import 'create_venue_repository.dart';

@Injectable(as: CreateVenueRepository)
class CreateVenueRepositoryImpl implements CreateVenueRepository {
  @override
  Future<void> createVenue({required String name, required List<String> genres}) async {
    // TODO: Implement actual backend logic
    await Future.delayed(const Duration(seconds: 1));
  }
}
