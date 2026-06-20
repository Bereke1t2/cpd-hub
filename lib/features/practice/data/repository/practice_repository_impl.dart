import 'package:dartz/dartz.dart';
import 'package:lab_portal/core/failure.dart';
import '../../domain/entity/review_item_entity.dart';
import '../../domain/entity/upsolve_item_entity.dart';
import '../../domain/repository/practice_repository.dart';
import '../datasources/practice_data_source.dart';
import '../models/review_item_model.dart';
import '../models/upsolve_item_model.dart';

class PracticeRepositoryImpl implements PracticeRepository {
  final PracticeDataSource _ds;
  PracticeRepositoryImpl(this._ds);

  @override
  Future<Either<List<ReviewItemEntity>, Failure>> getReviewQueue() async {
    try {
      return Left(await _ds.getReviewQueue());
    } catch (_) {
      return Right(Failure('Could not load review queue.'));
    }
  }

  @override
  Future<Either<void, Failure>> saveReviewItem(ReviewItemEntity item) async {
    try {
      await _ds.saveReviewItem(ReviewItemModel.fromEntity(item));
      return const Left(null);
    } catch (_) {
      return Right(Failure('Could not save review item.'));
    }
  }

  @override
  Future<Either<void, Failure>> addToReview(ReviewItemEntity item) async {
    try {
      await _ds.addToReview(ReviewItemModel.fromEntity(item));
      return const Left(null);
    } catch (_) {
      return Right(Failure('Could not add to review queue.'));
    }
  }

  @override
  Future<Either<void, Failure>> removeFromReview(String problemId) async {
    try {
      await _ds.removeFromReview(problemId);
      return const Left(null);
    } catch (_) {
      return Right(Failure('Could not remove from review queue.'));
    }
  }

  @override
  Future<Either<List<UpsolveItemEntity>, Failure>> getUpsolves() async {
    try {
      return Left(await _ds.getUpsolves());
    } catch (_) {
      return Right(Failure('Could not load upsolve list.'));
    }
  }

  @override
  Future<Either<void, Failure>> saveUpsolve(UpsolveItemEntity item) async {
    try {
      await _ds.saveUpsolve(UpsolveItemModel.fromEntity(item));
      return const Left(null);
    } catch (_) {
      return Right(Failure('Could not save upsolve item.'));
    }
  }

  @override
  Future<Either<void, Failure>> addUpsolve(UpsolveItemEntity item) async {
    try {
      await _ds.addUpsolve(UpsolveItemModel.fromEntity(item));
      return const Left(null);
    } catch (_) {
      return Right(Failure('Could not add upsolve item.'));
    }
  }
}
