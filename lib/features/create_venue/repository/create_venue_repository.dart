abstract class CreateVenueRepository {
  Future<void> createVenue({
    required String name,
  });

  Future<bool> isVenueNameAvailable(String name);
}
