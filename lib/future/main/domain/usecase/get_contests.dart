import 'package:dartz/dartz.dart';

import 'package:cpd_hub/core/failure.dart';

import '../entitiy/contest_entitiy.dart';
import '../repository/main_repo.dart';

class GetContests {
  final MainRepo repository;

  GetContests(this.repository);

  Future<Either<List<ContestEntitiy>, Failure>> call({int page = 1, int limit = 20}) async {
    return await repository.getContests(page: page, limit: limit);
  }
}
