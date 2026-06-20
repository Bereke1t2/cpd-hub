import 'package:dartz/dartz.dart';
import 'package:lab_portal/core/failure.dart';
import '../repository/main_repo.dart';

class UnmarkSolved {
  final MainRepo repository;
  UnmarkSolved(this.repository);

  Future<Either<void, Failure>> call(String problemId) =>
      repository.unmarkProblemAsSolved(problemId);
}
