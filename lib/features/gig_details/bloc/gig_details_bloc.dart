import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../dashboard/data/repositories/dashboard_repository.dart';
import 'gig_details_event.dart';
import 'gig_details_state.dart';

@injectable
class GigDetailsBloc extends Bloc<GigDetailsEvent, GigDetailsState> {
  final DashboardRepository _repository;

  GigDetailsBloc(this._repository) : super(const GigDetailsState.initial()) {
    on<DeleteRequested>((event, emit) async {
      emit(const GigDetailsState.deleting());
      try {
        await _repository.deleteGig(event.gigId);
        emit(const GigDetailsState.deleted());
      } catch (e) {
        emit(GigDetailsState.error(e.toString()));
      }
    });
  }
}
