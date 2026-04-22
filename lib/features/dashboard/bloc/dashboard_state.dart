import 'package:freezed_annotation/freezed_annotation.dart';
import '../data/entities/gig.dart';

part 'dashboard_state.freezed.dart';

@freezed
class DashboardState with _$DashboardState {
  const factory DashboardState.initial() = _Initial;
  const factory DashboardState.loading() = _Loading;
  const factory DashboardState.loaded({
    required String venueId,
    required List<Gig> gigs,
    required String gigLink,
    required String venueName,
  }) = _Loaded;
  const factory DashboardState.noVenue() = _NoVenue;
  const factory DashboardState.accountDeleted() = _AccountDeleted;
  const factory DashboardState.error({required String message}) = _Error;
}
