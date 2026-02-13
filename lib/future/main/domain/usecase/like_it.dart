import 'package:dartz/dartz.dart';

import 'package:cpd_hub/core/failure.dart';

import '../repository/main_repo.dart';

class LikeIt {
  final MainRepo repository;

  LikeIt(this.repository);

  Future<Either<void, Failure>> call(String problemId) async {
    return await repository.likeProblem(problemId);
  }
}
