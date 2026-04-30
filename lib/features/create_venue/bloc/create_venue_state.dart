part of 'create_venue_bloc.dart';

abstract class CreateVenueState {}

class CreateVenueInitial extends CreateVenueState {}

class CreateVenueLoading extends CreateVenueState {}

class CreateVenueSuccess extends CreateVenueState {
  final String venueName;

  CreateVenueSuccess({required this.venueName});
}

class CreateVenueNameTaken extends CreateVenueState {
  final String name;

  CreateVenueNameTaken({required this.name});
}

class CreateVenueFailure extends CreateVenueState {
  final String error;

  CreateVenueFailure({required this.error});
}
