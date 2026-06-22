import 'package:dartz/dartz.dart';
import 'package:lab_portal/core/failure.dart';
import '../repository/practice_repository.dart';
import '../service/sm2_scheduler.dart';

class AddToReview {
  final PracticeRepository repo;
  final Sm2Scheduler scheduler;
  AddToReview(this.repo, {Sm2Scheduler? scheduler})
      : scheduler = scheduler ?? const Sm2Scheduler();

  Future<Either<void, Failure>> call(String problemId) {
    final item = scheduler.enqueue(problemId, DateTime.now());
    return repo.addToReview(item);
  }
}
