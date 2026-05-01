import 'package:freezed_annotation/freezed_annotation.dart';

part 'gig_applications_state.freezed.dart';

@freezed
class GigApplicationsState with _$GigApplicationsState {
  const factory GigApplicationsState.initial() = _Initial;
  const factory GigApplicationsState.confirming() = _Confirming;
  const factory GigApplicationsState.confirmed() = _Confirmed;
  const factory GigApplicationsState.error({required String message}) = _Error;
}
