part of 'create_venue_bloc.dart';

abstract class CreateVenueEvent {}

class CreateVenueSubmitted extends CreateVenueEvent {
  final String name;

  CreateVenueSubmitted({required this.name});
}
