// Pure Dart — no Flutter, no I/O. Testable with no mocks.
// SM-2 spaced-repetition algorithm adapted for problem review.
//
// Grade scale (same as classic SM-2):
//   5 = perfect recall    4 = correct with hesitation
//   3 = correct with difficulty   2 = incorrect but easy recall
//   1 = incorrect    0 = complete blackout
//
// For CPD_HUB we simplify to two outcomes:
//   "Got it"  → grade 4   "Forgot / struggled" → grade 1

import '../entity/review_item_entity.dart';

class Sm2Scheduler {
  static const double _minEase = 1.3;
  static const double _initialEase = 2.5;

  const Sm2Scheduler();

  /// Create a brand-new review item for a problem (first enqueue).
  ReviewItemEntity enqueue(String problemId, DateTime now) {
    final today = _day(now);
    return ReviewItemEntity(
      problemId: problemId,
      dueDate: today.add(const Duration(days: 1)),
      interval: 1,
      ease: _initialEase,
      repetitions: 0,
    );
  }

  /// Apply a review result and return the updated item.
  ///
  /// [recalled] = true if the user solved it correctly; false if they struggled.
  ReviewItemEntity applyResult(
    ReviewItemEntity item,
    bool recalled,
    DateTime now,
  ) {
    final grade = recalled ? 4 : 1;

    int newInterval;
    double newEase;
    int newReps;

    if (grade < 3) {
      // Failed — reset repetitions, short interval.
      newReps = 0;
      newInterval = 1;
      newEase = (item.ease - 0.2).clamp(_minEase, 4.0);
    } else {
      newReps = item.repetitions + 1;
      newEase = (item.ease + 0.1 - (5 - grade) * (0.08 + (5 - grade) * 0.02))
          .clamp(_minEase, 4.0);

      if (newReps == 1) {
        newInterval = 1;
      } else if (newReps == 2) {
        newInterval = 6;
      } else {
        newInterval = (item.interval * item.ease).round();
      }
    }

    final today = _day(now);
    return item.copyWith(
      dueDate: today.add(Duration(days: newInterval)),
      interval: newInterval,
      ease: newEase,
      repetitions: newReps,
    );
  }

  /// Items due on or before today, oldest first.
  List<ReviewItemEntity> dueItems(
      List<ReviewItemEntity> all, DateTime now) {
    final today = _day(now);
    return all
        .where((i) => !i.dueDate.isAfter(today))
        .toList()
      ..sort((a, b) => a.dueDate.compareTo(b.dueDate));
  }

  DateTime _day(DateTime dt) => DateTime(dt.year, dt.month, dt.day);
}
