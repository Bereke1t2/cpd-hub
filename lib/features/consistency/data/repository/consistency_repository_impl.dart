import 'package:dartz/dartz.dart';
import 'package:lab_portal/core/failure.dart';
import '../../domain/entity/goal_entity.dart';
import '../../domain/entity/ladder_entity.dart';
import '../../domain/entity/streak_entity.dart';
import '../../domain/repository/consistency_repository.dart';
import '../datasources/consistency_data_source.dart';
import '../models/goal_model.dart';
import '../models/ladder_model.dart';
import '../models/streak_model.dart';

class ConsistencyRepositoryImpl implements ConsistencyRepository {
  final ConsistencyDataSource _ds;
  ConsistencyRepositoryImpl(this._ds);

  @override
  Future<Either<StreakEntity, Failure>> getStreak() async {
    try {
      return Left(await _ds.getStreak());
    } catch (e) {
      return Right(Failure('Could not load streak.'));
    }
  }

  @override
  Future<Either<void, Failure>> saveStreak(StreakEntity streak) async {
    try {
      await _ds.saveStreak(StreakModel.fromEntity(streak));
      return const Left(null);
    } catch (e) {
      return Right(Failure('Could not save streak.'));
    }
  }

  @override
  Future<Either<GoalEntity, Failure>> getGoal() async {
    try {
      return Left(await _ds.getGoal());
    } catch (e) {
      return Right(Failure('Could not load goal.'));
    }
  }

  @override
  Future<Either<void, Failure>> saveGoal(GoalEntity goal) async {
    try {
      await _ds.saveGoal(GoalModel.fromEntity(goal));
      return const Left(null);
    } catch (e) {
      return Right(Failure('Could not save goal.'));
    }
  }

  @override
  Future<Either<List<LadderEntity>, Failure>> getLadders() async {
    try {
      final base = await _ds.getLadders();
      // Overlay saved rung progress on top of default ladder definitions.
      final merged = <LadderEntity>[];
      for (final ladder in base) {
        final saved = await _ds.getSavedLadder(ladder.id);
        merged.add(saved ?? ladder);
      }
      return Left(merged);
    } catch (e) {
      return Right(Failure('Could not load ladders.'));
    }
  }

  @override
  Future<Either<void, Failure>> saveLadder(LadderEntity ladder) async {
    try {
      await _ds.saveLadder(LadderModel.fromEntity(ladder));
      return const Left(null);
    } catch (e) {
      return Right(Failure('Could not save ladder progress.'));
    }
  }
}
