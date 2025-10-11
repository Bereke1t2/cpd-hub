import 'package:dartz/dartz.dart';

import 'package:lab_portal/core/failure.dart';

import '../repository/main_repo.dart';

class MakeItSolved {
  final MainRepo repository;

  MakeItSolved(this.repository);

  Future<Either<void, Failure>> call(String problemId) async {
    return await repository.markProblemAsSolved(problemId);
  }
}
