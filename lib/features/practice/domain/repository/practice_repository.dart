import 'package:dartz/dartz.dart';
import 'package:lab_portal/core/failure.dart';
import '../entity/review_item_entity.dart';
import '../entity/upsolve_item_entity.dart';

// Left = success, Right = Failure (repo convention)
abstract class PracticeRepository {
  Future<Either<List<ReviewItemEntity>, Failure>> getReviewQueue();
  Future<Either<void, Failure>> saveReviewItem(ReviewItemEntity item);
  Future<Either<void, Failure>> addToReview(ReviewItemEntity item);
  Future<Either<void, Failure>> removeFromReview(String problemId);

  Future<Either<List<UpsolveItemEntity>, Failure>> getUpsolves();
  Future<Either<void, Failure>> saveUpsolve(UpsolveItemEntity item);
  Future<Either<void, Failure>> addUpsolve(UpsolveItemEntity item);
}
