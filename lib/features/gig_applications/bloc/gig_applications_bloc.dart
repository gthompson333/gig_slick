import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../data/repositories/gig_applications_repository.dart';
import 'gig_applications_event.dart';
import 'gig_applications_state.dart';

@injectable
class GigApplicationsBloc extends Bloc<GigApplicationsEvent, GigApplicationsState> {
  final GigApplicationsRepository _repository;

  GigApplicationsBloc(this._repository) : super(const GigApplicationsState.initial()) {
    on<ConfirmApplicationRequested>((event, emit) async {
      emit(const GigApplicationsState.confirming());
      try {
        await _repository.confirmApplication(
          event.gigId,
          event.applicationId,
          event.performerName,
        );
        emit(const GigApplicationsState.confirmed());
      } catch (e) {
        emit(GigApplicationsState.error(message: e.toString()));
      }
    });
  }
}
