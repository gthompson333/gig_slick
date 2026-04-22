import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../repository/create_venue_repository.dart';

part 'create_venue_event.dart';
part 'create_venue_state.dart';

@injectable
class CreateVenueBloc extends Bloc<CreateVenueEvent, CreateVenueState> {
  final CreateVenueRepository _repository;

  CreateVenueBloc(this._repository) : super(CreateVenueInitial()) {
    on<CreateVenueSubmitted>(_onCreateVenueSubmitted);
  }

  Future<void> _onCreateVenueSubmitted(
    CreateVenueSubmitted event,
    Emitter<CreateVenueState> emit,
  ) async {
    emit(CreateVenueLoading());
    try {
      await _repository.createVenue(name: event.name);
      emit(CreateVenueSuccess(venueName: event.name));
    } catch (e) {
      emit(CreateVenueFailure(error: e.toString()));
    }
  }
}
