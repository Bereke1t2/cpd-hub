import 'package:dartz/dartz.dart';
import 'package:lab_portal/core/failure.dart';
import '../entity/streak_entity.dart';
import '../repository/consistency_repository.dart';

class SaveStreak {
  final ConsistencyRepository repo;
  SaveStreak(this.repo);
  Future<Either<void, Failure>> call(StreakEntity streak) =>
      repo.saveStreak(streak);
}
