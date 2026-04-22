import 'package:freezed_annotation/freezed_annotation.dart';

part 'dashboard_event.freezed.dart';

@freezed
class DashboardEvent with _$DashboardEvent {
  const factory DashboardEvent.loadRequested() = LoadDashboardRequested;
  const factory DashboardEvent.accountDeletionRequested() =
      AccountDeletionRequested;
}
