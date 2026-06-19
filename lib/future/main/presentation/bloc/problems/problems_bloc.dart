import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

import '../../../domain/entity/problem_entity.dart';
import '../../../domain/usecase/get_problems.dart';

part 'problems_event.dart';
part 'problems_state.dart';

class ProblemsBloc extends Bloc<ProblemsEvent, ProblemsState> {
  final GetProblems getProblems;

  List<ProblemEntity> _all = const [];

  ProblemsBloc({required this.getProblems}) : super(const ProblemsInitial()) {
    on<ProblemsStarted>(_onStarted);
    on<ProblemsSearchChanged>(_onSearchChanged);
  }

  Future<void> _onStarted(
    ProblemsStarted event,
    Emitter<ProblemsState> emit,
  ) async {
    emit(const ProblemsLoading());
    final result = await getProblems();
    result.fold(
      (problems) {
        _all = problems;
        emit(ProblemsLoaded(problems: problems));
      },
      (failure) => emit(ProblemsError(failure.message)),
    );
  }

  void _onSearchChanged(
    ProblemsSearchChanged event,
    Emitter<ProblemsState> emit,
  ) {
    final q = event.query.trim().toLowerCase();
    final filtered = q.isEmpty
        ? _all
        : _all
            .where((p) =>
                p.title.toLowerCase().contains(q) ||
                p.difficulty.toLowerCase().contains(q))
            .toList();

    emit(ProblemsLoaded(problems: filtered, query: event.query));
  }
}
