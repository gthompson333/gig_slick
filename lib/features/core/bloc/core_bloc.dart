import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'core_event.dart';
import 'core_state.dart';

@injectable
class CoreBloc extends Bloc<CoreEvent, CoreState> {
  CoreBloc() : super(CoreInitial()) {
    on<CoreStarted>((event, emit) {
      // TODO: implement logic
    });
  }
}
