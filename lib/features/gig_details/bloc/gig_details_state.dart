import 'package:freezed_annotation/freezed_annotation.dart';

part 'gig_details_state.freezed.dart';

@freezed
class GigDetailsState with _$GigDetailsState {
  const factory GigDetailsState.initial() = Initial;
  const factory GigDetailsState.deleting() = Deleting;
  const factory GigDetailsState.deleted() = Deleted;
  const factory GigDetailsState.goingLive() = GoingLive;
  const factory GigDetailsState.live() = Live;
  const factory GigDetailsState.updatingNotes() = UpdatingNotes;
  const factory GigDetailsState.notesUpdated() = NotesUpdated;
  const factory GigDetailsState.error(String message) = Error;
}
