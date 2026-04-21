import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../core/constants/constants.dart';
import '../data/create_gig_request.dart';
import '../data/repositories/create_gig_repository.dart';
import 'create_gig_event.dart';
import 'create_gig_state.dart';

@injectable
class CreateGigBloc extends Bloc<CreateGigEvent, CreateGigState> {
  final CreateGigRepository _repository;

  CreateGigBloc(this._repository) : super(CreateGigState.initial()) {
    on<Started>((event, emit) {
      emit(state.copyWith(venueId: event.venueId));
    });

    on<GuaranteeChanged>((event, emit) {
      emit(state.copyWith(baseGuarantee: event.amount));
    });

    on<SplitToggled>((event, emit) {
      emit(state.copyWith(is7030Split: event.is7030));
    });

    on<GenreToggled>((event, emit) {
      final currentGenres = List<String>.from(state.selectedGenres);
      if (currentGenres.contains(event.genre)) {
        currentGenres.remove(event.genre);
      } else {
        currentGenres.add(event.genre);
      }
      emit(state.copyWith(selectedGenres: currentGenres));
    });

    on<DateChanged>((event, emit) {
      emit(state.copyWith(selectedDate: event.date));
    });

    on<LoadInTimeChanged>((event, emit) {
      emit(state.copyWith(loadInTime: event.time));
    });

    on<SetTimesChanged>((event, emit) {
      emit(state.copyWith(setTimes: event.times));
    });

    on<VenueNotesChanged>((event, emit) {
      emit(state.copyWith(venueNotes: event.notes));
    });

    on<SubmitRequested>((event, emit) async {
      emit(state.copyWith(isSubmitting: true, errorMessage: null));
      try {
        final request = CreateGigRequest(
          venueId: state.venueId,
          date: state.selectedDate,
          baseGuarantee: state.baseGuarantee,
          is7030Split: state.is7030Split,
          targetGenres: state.selectedGenres,
          loadInTime: state.loadInTime,
          setTimes: state.setTimes,
          venueNotes: state.venueNotes,
        );
        await _repository.createGig(request);
        emit(state.copyWith(isSubmitting: false, isSuccess: true));
      } catch (e) {
        emit(state.copyWith(
          isSubmitting: false,
          errorMessage: e.toString(),
        ));
      }
    });
  }
}
