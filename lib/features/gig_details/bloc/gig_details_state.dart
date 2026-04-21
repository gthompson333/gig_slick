import 'package:freezed_annotation/freezed_annotation.dart';

part 'gig_details_state.freezed.dart';

@freezed
class GigDetailsState with _$GigDetailsState {
  const factory GigDetailsState.initial() = Initial;
  const factory GigDetailsState.deleting() = Deleting;
  const factory GigDetailsState.deleted() = Deleted;
  const factory GigDetailsState.error(String message) = Error;
}
