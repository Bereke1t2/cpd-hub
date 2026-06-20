import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entity/goal_entity.dart';
import '../../../domain/usecase/get_goal.dart';
import '../../../domain/usecase/save_goal.dart';

part 'goals_state.dart';

class GoalsCubit extends Cubit<GoalsState> {
  final GetGoal _getGoal;
  final SaveGoal _saveGoal;

  GoalsCubit({required GetGoal getGoal, required SaveGoal saveGoal})
      : _getGoal = getGoal,
        _saveGoal = saveGoal,
        super(const GoalsInitial());

  Future<void> load() async {
    final result = await _getGoal();
    result.fold(
      (goal) => emit(GoalsLoaded(goal)),
      (_) => emit(GoalsLoaded(GoalEntity.defaultGoal())),
    );
  }

  /// Call alongside StreakCubit.onProblemSolved().
  Future<void> onProblemSolved() async {
    if (state is! GoalsLoaded) return;
    final current = (state as GoalsLoaded).goal;
    final updated = current.copyWith(progress: current.progress + 1);
    emit(GoalsLoaded(updated));
    await _saveGoal(updated);
  }

  Future<void> updateTarget(int newTarget) async {
    if (state is! GoalsLoaded) return;
    final updated = (state as GoalsLoaded).goal.copyWith(target: newTarget);
    emit(GoalsLoaded(updated));
    await _saveGoal(updated);
  }
}
