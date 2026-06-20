import 'package:dartz/dartz.dart';
import 'package:lab_portal/core/failure.dart';
import '../entity/goal_entity.dart';
import '../entity/ladder_entity.dart';
import '../entity/streak_entity.dart';

// Left = success, Right = Failure (repo convention — see docs/00-conventions)
abstract class ConsistencyRepository {
  Future<Either<StreakEntity, Failure>> getStreak();
  Future<Either<void, Failure>> saveStreak(StreakEntity streak);

  Future<Either<GoalEntity, Failure>> getGoal();
  Future<Either<void, Failure>> saveGoal(GoalEntity goal);

  Future<Either<List<LadderEntity>, Failure>> getLadders();
  Future<Either<void, Failure>> saveLadder(LadderEntity ladder);
}
