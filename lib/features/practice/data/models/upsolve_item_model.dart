import '../../domain/entity/upsolve_item_entity.dart';

class UpsolveItemModel extends UpsolveItemEntity {
  const UpsolveItemModel({
    required super.contestId,
    required super.contestTitle,
    required super.problemId,
    required super.problemTitle,
    required super.resolved,
  });

  factory UpsolveItemModel.fromEntity(UpsolveItemEntity e) => UpsolveItemModel(
        contestId: e.contestId,
        contestTitle: e.contestTitle,
        problemId: e.problemId,
        problemTitle: e.problemTitle,
        resolved: e.resolved,
      );

  factory UpsolveItemModel.fromJson(Map<String, dynamic> j) => UpsolveItemModel(
        contestId: (j['contest_id'] ?? '') as String,
        contestTitle: (j['contest_title'] ?? '') as String,
        problemId: (j['problem_id'] ?? '') as String,
        problemTitle: (j['problem_title'] ?? '') as String,
        resolved: (j['resolved'] ?? false) as bool,
      );

  Map<String, dynamic> toJson() => {
        'contest_id': contestId,
        'contest_title': contestTitle,
        'problem_id': problemId,
        'problem_title': problemTitle,
        'resolved': resolved,
      };
}
