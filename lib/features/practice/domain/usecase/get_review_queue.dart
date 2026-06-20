import 'package:dartz/dartz.dart';
import 'package:lab_portal/core/failure.dart';
import '../entity/review_item_entity.dart';
import '../repository/practice_repository.dart';

class GetReviewQueue {
  final PracticeRepository repo;
  GetReviewQueue(this.repo);
  Future<Either<List<ReviewItemEntity>, Failure>> call() =>
      repo.getReviewQueue();
}
