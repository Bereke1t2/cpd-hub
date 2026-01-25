import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

import '../../../domain/entitiy/daily_problem_entitiy.dart';
import '../../../domain/usecase/get_daily_problm.dart';

part 'daily_problem_event.dart';
part 'daily_problem_state.dart';

class DailyProblemBloc extends Bloc<DailyProblemEvent, DailyProblemState> {
  final GetDailyProblems getDailyProblems;

  DailyProblemBloc({required this.getDailyProblems})
      : super(const DailyProblemInitial()) {
    on<DailyProblemStarted>(_onStarted);
  }

  Future<void> _onStarted(
    DailyProblemStarted event,
    Emitter<DailyProblemState> emit,
  ) async {
    emit(const DailyProblemLoading());
    final result = await getDailyProblems();
    result.fold(
      (daily) => emit(DailyProblemLoaded(daily)),
      (failure) => emit(DailyProblemError(failure.message)),
    );
  }
}
