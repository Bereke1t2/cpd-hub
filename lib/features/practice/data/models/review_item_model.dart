import '../../domain/entity/review_item_entity.dart';

class ReviewItemModel extends ReviewItemEntity {
  const ReviewItemModel({
    required super.problemId,
    required super.dueDate,
    required super.interval,
    required super.ease,
    required super.repetitions,
  });

  factory ReviewItemModel.fromEntity(ReviewItemEntity e) => ReviewItemModel(
        problemId: e.problemId,
        dueDate: e.dueDate,
        interval: e.interval,
        ease: e.ease,
        repetitions: e.repetitions,
      );

  factory ReviewItemModel.fromJson(Map<String, dynamic> j) => ReviewItemModel(
        problemId: (j['problem_id'] ?? '') as String,
        dueDate: DateTime.parse(j['due_date'] as String),
        interval: (j['interval'] ?? 1) as int,
        ease: (j['ease'] ?? 2.5) as double,
        repetitions: (j['repetitions'] ?? 0) as int,
      );

  Map<String, dynamic> toJson() => {
        'problem_id': problemId,
        'due_date': dueDate.toIso8601String(),
        'interval': interval,
        'ease': ease,
        'repetitions': repetitions,
      };
}
