import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../data/performer_repository.dart';
import '../../dashboard/data/entities/gig.dart';
import 'performer_event.dart';
import 'performer_state.dart';

@injectable
class PerformerBloc extends Bloc<PerformerEvent, PerformerState> {
  final PerformerRepository _repository;

  PerformerBloc(this._repository) : super(const PerformerInitial()) {
    on<LoadGigRequested>((event, emit) async {
      emit(const PerformerLoading());
      try {
        final venueName = await _repository.getVenueName(event.venueId) ?? 'Unknown Venue';

        if (event.gigId.isEmpty) {
          // Venue-only link, handle gracefully or error since no gig
          emit(const PerformerError('Gig not found.'));
          return;
        }

        final gig = await _repository.getGig(event.gigId);
        if (gig == null) {
          emit(const PerformerError('Gig not found.'));
        } else {
          emit(PerformerLoaded(gig, venueName));
        }
      } catch (e) {
        emit(PerformerError(e.toString()));
      }
    });

    on<SubmitApplicationRequested>((event, emit) async {
      Gig? currentGig;
      String? currentVenueName;

      if (state is PerformerLoaded) {
        currentGig = (state as PerformerLoaded).gig;
        currentVenueName = (state as PerformerLoaded).venueName;
      } else if (state is PerformerSubmissionError) {
        currentGig = (state as PerformerSubmissionError).gig;
        currentVenueName = (state as PerformerSubmissionError).venueName;
      }

      if (currentGig != null && currentVenueName != null) {
        emit(PerformerSubmitting(currentGig, currentVenueName));
        try {
          await _repository.applyForGig(
            gigId: event.gigId,
            venueName: event.venueName,
            performerName: event.performerName,
            performerEmail: event.performerEmail,
            performerLink: event.performerLink,
          );
          emit(const PerformerSubmittedSuccess());
        } catch (e) {
          emit(PerformerSubmissionError(currentGig, currentVenueName, e.toString()));
        }
      }
    });

    on<LoadLiveGigsRequested>((event, emit) async {
      emit(const PerformerLoading());
      try {
        final venueName = await _repository.getVenueName(event.venueId) ?? 'Unknown Venue';
        final liveGigs = await _repository.getLiveGigs(event.venueId);
        emit(PerformerLiveGigsLoaded(liveGigs, venueName));
      } catch (e) {
        emit(PerformerError(e.toString()));
      }
    });
  }
}
