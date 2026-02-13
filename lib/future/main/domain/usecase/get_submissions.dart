import 'package:dartz/dartz.dart';
import 'package:cpd_hub/core/failure.dart';
import '../entitiy/submission_entity.dart';
import '../repository/main_repo.dart';

class GetSubmissions {
  final MainRepo repository;
  GetSubmissions(this.repository);

  Future<Either<List<SubmissionEntity>, Failure>> call(String username) async {
    return await repository.getSubmissions(username);
  }
}
