import 'package:dartz/dartz.dart';
import 'package:lab_portal/core/failure.dart';
import '../entity/review_item_entity.dart';
import '../repository/practice_repository.dart';
import '../service/sm2_scheduler.dart';

class SaveReviewResult {
  final PracticeRepository repo;
  final Sm2Scheduler scheduler;
  SaveReviewResult(this.repo, {Sm2Scheduler? scheduler})
      : scheduler = scheduler ?? const Sm2Scheduler();

  Future<Either<void, Failure>> call(
      ReviewItemEntity item, bool recalled) async {
    final updated = scheduler.applyResult(item, recalled, DateTime.now());
    return repo.saveReviewItem(updated);
  }
}
