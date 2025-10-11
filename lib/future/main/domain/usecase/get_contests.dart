import 'package:dartz/dartz.dart';

import 'package:lab_portal/core/failure.dart';

import '../entitiy/contest_entitiy.dart';
import '../repository/main_repo.dart';

class GetContests {
  final MainRepo repository;

  GetContests(this.repository);

  Future<Either<List<ContestEntitiy>, Failure>> call() async {
    return await repository.getContests();
  }
}