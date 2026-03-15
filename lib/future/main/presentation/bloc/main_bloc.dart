import 'package:bloc/bloc.dart';
import 'package:cpd_hub/future/main/domain/usecase/get_daily_problm.dart';
import 'package:meta/meta.dart';

import '../../domain/usecase/get_problems.dart';

part 'main_event.dart';
part 'main_state.dart';

class MainBloc extends Bloc<MainEvent, MainState> {
  final GetDailyProblems getDailyProblems;
  final GetProblems getProblems;

  MainBloc(this.getDailyProblems, this.getProblems) : super(MainInitial()) {
    on<MainEvent>((event, emit) {
      if (event is LoadDailyProblemsEvent) {
        _loadDailyProblems(emit);
      } else if (event is LoadProblemsEvent) {
        _loadProblems(emit);
      }
    });
  }

  Future<void> _loadDailyProblems(Emitter<MainState> emit) async {
    emit(LoadingState());
    final result = await getDailyProblems();
    result.fold(
      (failure) => emit(ErrorState(failure.toString())),
      (dailyProblems) =>
          emit(DailyProblemsLoadedState(dailyProblems: dailyProblems as List)),
    );
  }

  Future<void> _loadProblems(Emitter<MainState> emit) async {
    emit(LoadingState());
    final result = await getProblems();
    result.fold(
      (failure) => emit(ErrorState(failure.toString())),
      (problems) =>
          emit(ProblemsLoadedState(problems as List, hasReachedMax: false)),
    );
  }
}
