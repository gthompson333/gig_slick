import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../core/services/link_service.dart';
import '../data/entities/gig.dart';
import '../data/repositories/dashboard_repository.dart';
import 'dashboard_event.dart';
import 'dashboard_state.dart';

@injectable
class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  final DashboardRepository _repository;
  final LinkService _linkService;

  DashboardBloc(this._repository, this._linkService) : super(const DashboardState.initial()) {
    on<LoadDashboardRequested>((event, emit) async {
      emit(const DashboardState.loading());
      try {
        final venueData = await _repository.getVenueForUser();
        if (venueData == null) {
          emit(const DashboardState.noVenue());
          return;
        }

        final venueName = venueData['name'] as String;
        final venueId = venueData['id'] as String;
        final performerLink = _linkService.generateVenueLink(venueId);

        await emit.forEach<List<Gig>>(
          _repository.getScheduledGigsStream(venueId),
          onData: (gigs) => DashboardState.loaded(
            venueId: venueId,
            gigs: gigs,
            gigLink: performerLink,
            venueName: venueName,
          ),
          onError: (error, stackTrace) =>
              DashboardState.error(message: error.toString()),
        );
      } catch (e) {
        emit(DashboardState.error(message: e.toString()));
      }
    });

    on<AccountDeletionRequested>((event, emit) async {
      try {
        await _repository.deleteAccount();
        emit(const DashboardState.accountDeleted());
      } catch (e) {
        emit(DashboardState.error(message: e.toString()));
      }
    });
  }
}
