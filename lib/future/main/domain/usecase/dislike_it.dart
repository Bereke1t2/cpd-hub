import 'package:dartz/dartz.dart';

import 'package:lab_portal/core/failure.dart';

import '../repository/main_repo.dart';

class DislikeIt {
  final MainRepo repository;

  DislikeIt(this.repository);

  Future<Either<void, Failure>> call(String problemId) async {
    return await repository.dislikeProblem(problemId);
  }
}
