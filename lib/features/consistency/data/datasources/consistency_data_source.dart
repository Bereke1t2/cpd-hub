import '../models/goal_model.dart';
import '../models/ladder_model.dart';
import '../models/streak_model.dart';

abstract class ConsistencyDataSource {
  Future<StreakModel> getStreak();
  Future<void> saveStreak(StreakModel streak);

  Future<GoalModel> getGoal();
  Future<void> saveGoal(GoalModel goal);

  /// Returns the base (default) ladders. Solved state is layered on top
  /// from saved overrides via [getSavedLadder] / [saveLadder].
  Future<List<LadderModel>> getLadders();
  Future<LadderModel?> getSavedLadder(String ladderId);
  Future<void> saveLadder(LadderModel ladder);
}
