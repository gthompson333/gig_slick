import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../data/performer_repository.dart';
import 'performer_event.dart';
import 'performer_state.dart';

@injectable
class PerformerBloc extends Bloc<PerformerEvent, PerformerState> {
  final PerformerRepository _repository;

  PerformerBloc(this._repository) : super(const PerformerInitial()) {
    on<LoadGigRequested>((event, emit) async {
      emit(const PerformerLoading());
      try {
        final gig = await _repository.getGig(event.gigId);
        if (gig == null) {
          emit(const PerformerError('Gig not found.'));
        } else {
          emit(PerformerLoaded(gig));
        }
      } catch (e) {
        emit(PerformerError(e.toString()));
      }
    });

    on<SubmitApplicationRequested>((event, emit) async {
      if (state is PerformerLoaded) {
        final currentGig = (state as PerformerLoaded).gig;
        emit(PerformerSubmitting(currentGig));
        try {
          await _repository.applyForGig(
            gigId: event.gigId,
            venueName: event.venueName,
            performerName: event.performerName,
            performerLink: event.performerLink,
          );
          emit(const PerformerSubmittedSuccess());
        } catch (e) {
          emit(PerformerError(e.toString()));
        }
      }
    });
  }
}
