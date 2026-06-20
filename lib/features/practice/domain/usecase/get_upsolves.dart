import 'package:dartz/dartz.dart';
import 'package:lab_portal/core/failure.dart';
import '../entity/upsolve_item_entity.dart';
import '../repository/practice_repository.dart';

class GetUpsolves {
  final PracticeRepository repo;
  GetUpsolves(this.repo);
  Future<Either<List<UpsolveItemEntity>, Failure>> call() =>
      repo.getUpsolves();
}
