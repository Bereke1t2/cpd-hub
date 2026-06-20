import 'package:dartz/dartz.dart';
import 'package:lab_portal/core/failure.dart';
import '../entity/goal_entity.dart';
import '../repository/consistency_repository.dart';

class GetGoal {
  final ConsistencyRepository repo;
  GetGoal(this.repo);
  Future<Either<GoalEntity, Failure>> call() => repo.getGoal();
}
