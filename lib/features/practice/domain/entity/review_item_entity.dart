import 'package:equatable/equatable.dart';

class ReviewItemEntity extends Equatable {
  final String problemId;

  /// When to show this item next (local date).
  final DateTime dueDate;

  /// Current SM-2 interval in days.
  final int interval;

  /// SM-2 ease factor (starts at 2.5, minimum 1.3).
  final double ease;

  /// How many times this item has been reviewed.
  final int repetitions;

  const ReviewItemEntity({
    required this.problemId,
    required this.dueDate,
    required this.interval,
    required this.ease,
    required this.repetitions,
  });

  bool get isDueToday {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    return !dueDate.isAfter(today);
  }

  ReviewItemEntity copyWith({
    DateTime? dueDate,
    int? interval,
    double? ease,
    int? repetitions,
  }) =>
      ReviewItemEntity(
        problemId: problemId,
        dueDate: dueDate ?? this.dueDate,
        interval: interval ?? this.interval,
        ease: ease ?? this.ease,
        repetitions: repetitions ?? this.repetitions,
      );

  @override
  List<Object?> get props =>
      [problemId, dueDate, interval, ease, repetitions];
}
