import 'package:dartz/dartz.dart';

import 'package:lab_portal/core/failure.dart';

import '../entity/contest_entity.dart';
import '../repository/main_repo.dart';

class GetContests {
  final MainRepo repository;

  GetContests(this.repository);

  Future<Either<List<ContestEntity>, Failure>> call() async {
    return await repository.getContests();
  }
}