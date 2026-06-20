import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entity/streak_entity.dart';
import '../../../domain/service/streak_engine.dart';
import '../../../domain/usecase/get_streak.dart';
import '../../../domain/usecase/save_streak.dart';

part 'streak_state.dart';

class StreakCubit extends Cubit<StreakState> {
  final GetStreak _getStreak;
  final SaveStreak _saveStreak;
  final StreakEngine _engine;

  StreakCubit({
    required GetStreak getStreak,
    required SaveStreak saveStreak,
    StreakEngine engine = const StreakEngine(),
  })  : _getStreak = getStreak,
        _saveStreak = saveStreak,
        _engine = engine,
        super(const StreakInitial());

  Future<void> load() async {
    final result = await _getStreak();
    result.fold(
      (streak) {
        final rolled = _engine.onDayRollover(streak, DateTime.now());
        emit(StreakLoaded(rolled));
        if (rolled != streak) _persist(rolled);
      },
      (_) => emit(StreakLoaded(StreakEntity.empty())),
    );
  }

  /// Call whenever a problem is marked solved.
  Future<void> onProblemSolved() async {
    final current = state is StreakLoaded
        ? (state as StreakLoaded).streak
        : StreakEntity.empty();
    final updated = _engine.onSolve(current, DateTime.now());
    emit(StreakLoaded(updated));
    await _persist(updated);
  }

  Future<void> _persist(StreakEntity s) => _saveStreak(s);
}
