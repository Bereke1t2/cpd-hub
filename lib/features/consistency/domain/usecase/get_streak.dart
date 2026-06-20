import 'package:dartz/dartz.dart';
import 'package:lab_portal/core/failure.dart';
import '../entity/streak_entity.dart';
import '../repository/consistency_repository.dart';

class GetStreak {
  final ConsistencyRepository repo;
  GetStreak(this.repo);
  Future<Either<StreakEntity, Failure>> call() => repo.getStreak();
}
