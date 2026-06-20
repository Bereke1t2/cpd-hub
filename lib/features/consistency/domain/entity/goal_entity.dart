import 'package:equatable/equatable.dart';

enum GoalType { problemsPerWeek }

class GoalEntity extends Equatable {
  final String id;
  final GoalType type;
  final int target;
  final int progress;

  /// Start of the current period (Monday of the current week, time stripped).
  final DateTime periodStart;

  const GoalEntity({
    required this.id,
    required this.type,
    required this.target,
    required this.progress,
    required this.periodStart,
  });

  factory GoalEntity.defaultGoal() {
    final now = DateTime.now();
    final monday = DateTime(now.year, now.month, now.day - (now.weekday - 1));
    return GoalEntity(
      id: 'weekly-problems',
      type: GoalType.problemsPerWeek,
      target: 5,
      progress: 0,
      periodStart: monday,
    );
  }

  bool get isMet => progress >= target;
  double get ratio => target == 0 ? 0 : (progress / target).clamp(0.0, 1.0);

  String get label {
    switch (type) {
      case GoalType.problemsPerWeek:
        return 'Problems this week';
    }
  }

  GoalEntity copyWith({
    String? id,
    GoalType? type,
    int? target,
    int? progress,
    DateTime? periodStart,
  }) =>
      GoalEntity(
        id: id ?? this.id,
        type: type ?? this.type,
        target: target ?? this.target,
        progress: progress ?? this.progress,
        periodStart: periodStart ?? this.periodStart,
      );

  @override
  List<Object?> get props => [id, type, target, progress, periodStart];
}
