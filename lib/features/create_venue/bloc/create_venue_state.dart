part of 'create_venue_bloc.dart';

abstract class CreateVenueState {}

class CreateVenueInitial extends CreateVenueState {}

class CreateVenueLoading extends CreateVenueState {}

class CreateVenueSuccess extends CreateVenueState {}

class CreateVenueFailure extends CreateVenueState {
  final String error;

  CreateVenueFailure({required this.error});
}
