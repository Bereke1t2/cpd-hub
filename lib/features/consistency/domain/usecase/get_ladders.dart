import 'package:dartz/dartz.dart';
import 'package:lab_portal/core/failure.dart';
import '../entity/ladder_entity.dart';
import '../repository/consistency_repository.dart';

class GetLadders {
  final ConsistencyRepository repo;
  GetLadders(this.repo);
  Future<Either<List<LadderEntity>, Failure>> call() => repo.getLadders();
}
