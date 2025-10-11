import 'package:dartz/dartz.dart';

import 'package:lab_portal/core/failure.dart';

import '../entitiy/problem_entitiy.dart';
import '../repository/main_repo.dart';

class GetProblems {
  final MainRepo repository;

  GetProblems(this.repository);

  Future<Either<List<ProblemEntity>, Failure>> call() async {
    return await repository.getProblems();
  }
}