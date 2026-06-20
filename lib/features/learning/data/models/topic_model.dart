import '../../domain/entity/topic_entity.dart';

class TopicModel extends TopicEntity {
  const TopicModel({
    required super.id,
    required super.name,
    required super.category,
    required super.summary,
    required super.difficulty,
    required super.prerequisiteIds,
    required super.problemIds,
    required super.referenceUrls,
  });

  factory TopicModel.fromJson(Map<String, dynamic> j) => TopicModel(
        id: (j['id'] ?? '') as String,
        name: (j['name'] ?? '') as String,
        category: (j['category'] ?? '') as String,
        summary: (j['summary'] ?? '') as String,
        difficulty: (j['difficulty'] ?? 1) as int,
        prerequisiteIds: List<String>.from(j['prerequisite_ids'] ?? []),
        problemIds: List<String>.from(j['problem_ids'] ?? []),
        referenceUrls: List<String>.from(j['reference_urls'] ?? []),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'category': category,
        'summary': summary,
        'difficulty': difficulty,
        'prerequisite_ids': prerequisiteIds,
        'problem_ids': problemIds,
        'reference_urls': referenceUrls,
      };
}
