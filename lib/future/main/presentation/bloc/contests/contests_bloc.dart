import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

import '../../../domain/entity/contest_entity.dart';
import '../../../domain/usecase/get_contests.dart';

part 'contests_event.dart';
part 'contests_state.dart';

class ContestsBloc extends Bloc<ContestsEvent, ContestsState> {
  final GetContests getContests;

  List<ContestEntity> _all = const [];

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
        emit(ContestsLoaded(all: contests));
      },
      (failure) => emit(ContestsError(failure.message)),
    );
  }

  void _onFilterChanged(
    ContestsFilterChanged event,
    Emitter<ContestsState> emit,
  ) {
    final current = state is ContestsLoaded
        ? (state as ContestsLoaded).platform
        : 'All';
    if (current == event.filter) return;
    emit(ContestsLoaded(all: _all, platform: event.filter));
  }
}
