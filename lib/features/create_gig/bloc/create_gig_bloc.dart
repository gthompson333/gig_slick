import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../data/create_gig_request.dart';
import '../data/repositories/create_gig_repository.dart';
import 'create_gig_event.dart';
import 'create_gig_state.dart';

@injectable
class CreateGigBloc extends Bloc<CreateGigEvent, CreateGigState> {
  final CreateGigRepository _repository;

  CreateGigBloc(this._repository) : super(CreateGigState.initial()) {
    on<Started>((event, emit) {
      final initialGig = event.initialGig;
      if (initialGig != null) {
        emit(
          state.copyWith(
            venueId: event.venueId,
            gigId: initialGig.id,
            baseGuarantee: initialGig.baseGuarantee,
            is7030Split: initialGig.is7030Split,
            selectedGenres: initialGig.genres,
            selectedDate: initialGig.date,
            loadInTime: initialGig.loadInTime,
            setTime: initialGig.setTime,
            venueNotes: initialGig.venueNotes,
            status: initialGig.status.name,
          ),
        );
      } else {
        emit(state.copyWith(venueId: event.venueId));
      }
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

    on<SetTimeChanged>((event, emit) {
      emit(state.copyWith(setTime: event.time));
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
          genres: state.selectedGenres,
          loadInTime: state.loadInTime,
          setTime: state.setTime,
          venueNotes: state.venueNotes,
          status: state.status,
        );

        if (state.gigId != null) {
          await _repository.updateGig(state.gigId!, request);
        } else {
          await _repository.createGig(request);
        }

        emit(state.copyWith(isSubmitting: false, isSuccess: true));
      } catch (e) {
        emit(state.copyWith(isSubmitting: false, errorMessage: e.toString()));
      }
    });
  }
}
