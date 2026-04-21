import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../data/entities/gig.dart';
import '../data/repositories/dashboard_repository.dart';
import 'dashboard_event.dart';
import 'dashboard_state.dart';

@injectable
class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  final DashboardRepository _repository;

  DashboardBloc(this._repository) : super(const DashboardState.initial()) {
    on<LoadDashboardRequested>((event, emit) async {
      emit(const DashboardState.loading());
      try {
        final venueData = await _repository.getVenueForUser();
        if (venueData == null) {
          emit(const DashboardState.noVenue());
          return;
        }

        final venueName = venueData['name'] as String;
        // Normalize name for the link (lowercase kebab-case)
        final normalizedName = venueName.toLowerCase().replaceAll(' ', '-');
        final performerLink = 'gigslick.link/$normalizedName';
        
        final venueId = venueData['id'] ?? normalizedName; // Fallback if ID is missing

        await emit.forEach<List<Gig>>(
          _repository.getScheduledGigsStream(venueId as String),
          onData: (gigs) => DashboardState.loaded(
            venueId: venueId as String,
            gigs: gigs,
            gig_link: performerLink,
            venueName: venueName,
          ),
          onError: (error, stackTrace) =>
              DashboardState.error(message: error.toString()),
        );
      } catch (e) {
        emit(DashboardState.error(message: e.toString()));
      }
    });
  }
}
