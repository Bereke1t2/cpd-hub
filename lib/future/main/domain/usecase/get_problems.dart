import 'package:dartz/dartz.dart';

import 'package:lab_portal/core/failure.dart';

import '../entity/problem_entity.dart';
import '../repository/main_repo.dart';

class GetProblems {
  final MainRepo repository;

  GetProblems(this.repository);

  Future<Either<List<ProblemEntity>, Failure>> call() async {
    return await repository.getProblems();
  }
}