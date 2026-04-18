import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../domain/entities/create_slot_request.dart';
import '../../domain/repositories/create_slot_repository.dart';
import 'create_slot_event.dart';
import 'create_slot_state.dart';

@injectable
class CreateSlotBloc extends Bloc<CreateSlotEvent, CreateSlotState> {
  final CreateSlotRepository _repository;

  CreateSlotBloc(this._repository) : super(CreateSlotState.initial()) {
    on<GuaranteeChanged>((event, emit) {
      emit(state.copyWith(baseGuarantee: event.amount));
    });

    on<SplitToggled>((event, emit) {
      emit(state.copyWith(is7030Split: event.is7030));
    });

    on<GenreToggled>((event, emit) {
      final currentGenres = List<String>.from(state.selectedGenres);
      if (currentGenres.contains(event.genre)) {
        currentGenres.remove(event.genre);
      } else {
        currentGenres.add(event.genre);
      }
      emit(state.copyWith(selectedGenres: currentGenres));
    });

    on<SubmitRequested>((event, emit) async {
      emit(state.copyWith(isSubmitting: true, errorMessage: null));
      try {
        final request = CreateSlotRequest(
          date: DateTime.now(), // Stubbed
          baseGuarantee: state.baseGuarantee,
          is7030Split: state.is7030Split,
          targetGenres: state.selectedGenres,
          loadInTime: '7:00 PM', // Stubbed
          setTimes: '9:00 PM', // Stubbed
          venueNotes: '', // Stubbed
        );
        await _repository.createSlot(request);
        emit(state.copyWith(isSubmitting: false, isSuccess: true));
      } catch (e) {
        emit(state.copyWith(
          isSubmitting: false,
          errorMessage: e.toString(),
        ));
      }
    });
  }
}
