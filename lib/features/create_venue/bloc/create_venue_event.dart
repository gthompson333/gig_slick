part of 'create_venue_bloc.dart';

abstract class CreateVenueEvent {}

class CreateVenueSubmitted extends CreateVenueEvent {
  final String name;
  final List<String> genres;

  CreateVenueSubmitted({required this.name, required this.genres});
}
