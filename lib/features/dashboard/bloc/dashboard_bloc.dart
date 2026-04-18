import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../data/entities/slot.dart';
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
        final magicLink = await _repository.getMagicLinkUrl();
        await emit.forEach<List<Slot>>(
          _repository.getScheduledSlotsStream(),
          onData: (slots) => DashboardState.loaded(
            slots: slots,
            magicLink: magicLink,
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
