import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../dashboard/data/repositories/dashboard_repository.dart';
import 'gig_details_event.dart';
import 'gig_details_state.dart';

@injectable
class GigDetailsBloc extends Bloc<GigDetailsEvent, GigDetailsState> {
  final DashboardRepository _repository;

  GigDetailsBloc(this._repository) : super(const GigDetailsState.initial()) {
    on<DeleteRequested>((event, emit) async {
      emit(const GigDetailsState.deleting());
      try {
        await _repository.deleteGig(event.gigId);
        emit(const GigDetailsState.deleted());
      } catch (e) {
        emit(GigDetailsState.error(e.toString()));
      }
    });

    on<PublishRequested>((event, emit) async {
      emit(const GigDetailsState.goingLive());
      try {
        await _repository.publishGig(event.gigId);
        emit(const GigDetailsState.live());
      } catch (e) {
        emit(GigDetailsState.error(e.toString()));
      }
    });

    on<VenueNotesUpdated>((event, emit) async {
      emit(const GigDetailsState.updatingNotes());
      try {
        await _repository.updateVenueNotes(event.gigId, event.notes);
        emit(const GigDetailsState.notesUpdated());
      } catch (e) {
        emit(GigDetailsState.error(e.toString()));
      }
    });

    on<GigDetailsUpdated>((event, emit) async {
      emit(const GigDetailsState.updating());
      try {
        await _repository.updateGigDetails(
          gigId: event.gigId,
          loadInTime: event.loadInTime,
          setTime: event.setTime,
          baseGuarantee: event.baseGuarantee,
          genres: event.genres,
          venueNotes: event.venueNotes,
        );
        emit(const GigDetailsState.updated());
      } catch (e) {
        emit(GigDetailsState.error(e.toString()));
      }
    });
  }
}
