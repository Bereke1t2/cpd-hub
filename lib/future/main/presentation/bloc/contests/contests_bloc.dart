import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

import '../../../domain/entitiy/contest_entitiy.dart';
import '../../../domain/usecase/get_contests.dart';

part 'contests_event.dart';
part 'contests_state.dart';

class ContestsBloc extends Bloc<ContestsEvent, ContestsState> {
  final GetContests getContests;

  List<ContestEntitiy> _all = const [];

  ContestsBloc({required this.getContests}) : super(const ContestsInitial()) {
    on<ContestsStarted>(_onStarted);
    on<ContestsFilterChanged>(_onFilterChanged);
  }

  Future<void> _onStarted(
    ContestsStarted event,
    Emitter<ContestsState> emit,
  ) async {
    emit(const ContestsLoading());
    final result = await getContests();
    result.fold(
      (contests) {
        _all = contests;
        emit(ContestsLoaded(contests: contests));
      },
      (failure) => emit(ContestsError(failure.message)),
    );
  }

  void _onFilterChanged(
    ContestsFilterChanged event,
    Emitter<ContestsState> emit,
  ) {
    // With real API, filter could be server-driven. For now, keep it local.
    emit(ContestsLoaded(contests: _all, filter: event.filter));
  }
}
