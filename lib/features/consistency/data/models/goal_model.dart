import '../../domain/entity/goal_entity.dart';

class GoalModel extends GoalEntity {
  const GoalModel({
    required super.id,
    required super.type,
    required super.target,
    required super.progress,
    required super.periodStart,
  });

  factory GoalModel.fromEntity(GoalEntity e) => GoalModel(
        id: e.id,
        type: e.type,
        target: e.target,
        progress: e.progress,
        periodStart: e.periodStart,
      );

  factory GoalModel.fromJson(Map<String, dynamic> j) => GoalModel(
        id: (j['id'] ?? 'weekly-problems') as String,
        type: GoalType.values.firstWhere(
          (t) => t.name == j['type'],
          orElse: () => GoalType.problemsPerWeek,
        ),
        target: (j['target'] ?? 5) as int,
        progress: (j['progress'] ?? 0) as int,
        periodStart: j['period_start'] != null
            ? DateTime.parse(j['period_start'] as String)
            : GoalEntity.defaultGoal().periodStart,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'type': type.name,
        'target': target,
        'progress': progress,
        'period_start': periodStart.toIso8601String(),
      };
}
