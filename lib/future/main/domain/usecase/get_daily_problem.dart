import 'package:dartz/dartz.dart';
import 'package:lab_portal/core/failure.dart';
import 'package:lab_portal/future/main/domain/entity/daily_problem_entity.dart';
import '../repository/main_repo.dart';

class GetDailyProblems {
  final MainRepo repository;
  GetDailyProblems(this.repository);

  Future<Either<DailyProblemEntity, Failure>> call() async {
    return await repository.getDailyProblems();
  }
}
