import 'package:dartz/dartz.dart';
import 'package:lab_portal/core/failure.dart';
import '../entity/goal_entity.dart';
import '../repository/consistency_repository.dart';

class SaveGoal {
  final ConsistencyRepository repo;
  SaveGoal(this.repo);
  Future<Either<void, Failure>> call(GoalEntity goal) => repo.saveGoal(goal);
}
