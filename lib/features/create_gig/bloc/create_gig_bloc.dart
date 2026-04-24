import 'package:cloud_firestore/cloud_firestore.dart';
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
            venueName: event.venueName,
            gigId: initialGig.id,
            baseGuarantee: initialGig.baseGuarantee,
            selectedGenres: initialGig.genres,
            selectedDate: initialGig.date,
            loadInTime: initialGig.loadInTime,
            setTime: initialGig.setTime,
            venueNotes: initialGig.venueNotes,
            status: initialGig.status.name,
          ),
        );
      } else {
        emit(state.copyWith(venueId: event.venueId, venueName: event.venueName));
      }
    });

    on<GuaranteeChanged>((event, emit) {
      emit(state.copyWith(baseGuarantee: event.amount));
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
        final gigId = state.gigId ?? FirebaseFirestore.instance.collection('gigs').doc().id;
        final status = event.status ?? state.status;
        final request = CreateGigRequest(
          venueId: state.venueId,
          gigId: gigId,
          date: state.selectedDate,
          baseGuarantee: state.baseGuarantee,

          genres: state.selectedGenres,
          loadInTime: state.loadInTime,
          setTime: state.setTime,
          venueNotes: state.venueNotes,
          status: status,
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
