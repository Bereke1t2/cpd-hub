import 'package:dartz/dartz.dart';

import 'package:lab_portal/core/failure.dart';

import '../entitiy/daily_problem_entitiy.dart';
import '../repository/main_repo.dart';

class GetDailyProblems {
  final MainRepo repository;

  GetDailyProblems(this.repository);

  Future<Either<DailyProblemEntitiy, Failure>> call() async {
    return await repository.getDailyProblems();
  }
}
