import '../../domain/entity/ladder_entity.dart';

class LadderRungModel extends LadderRungEntity {
  const LadderRungModel({
    required super.problemId,
    required super.rating,
    required super.solved,
    super.topicId,
  });

  factory LadderRungModel.fromJson(Map<String, dynamic> j) => LadderRungModel(
        problemId: (j['problem_id'] ?? '') as String,
        rating: (j['rating'] ?? 1000) as int,
        solved: (j['solved'] ?? false) as bool,
        topicId: j['topic_id'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'problem_id': problemId,
        'rating': rating,
        'solved': solved,
        'topic_id': topicId,
      };
}

class LadderModel extends LadderEntity {
  const LadderModel({
    required super.id,
    required super.title,
    required super.fromRating,
    required super.toRating,
    required super.rungs,
  });

  factory LadderModel.fromEntity(LadderEntity e) => LadderModel(
        id: e.id,
        title: e.title,
        fromRating: e.fromRating,
        toRating: e.toRating,
        rungs: e.rungs
            .map((r) => LadderRungModel(
                  problemId: r.problemId,
                  rating: r.rating,
                  solved: r.solved,
                  topicId: r.topicId,
                ))
            .toList(),
      );

  factory LadderModel.fromJson(Map<String, dynamic> j) => LadderModel(
        id: (j['id'] ?? '') as String,
        title: (j['title'] ?? '') as String,
        fromRating: (j['from_rating'] ?? 1000) as int,
        toRating: (j['to_rating'] ?? 1200) as int,
        rungs: ((j['rungs'] as List?) ?? [])
            .map((r) => LadderRungModel.fromJson(r as Map<String, dynamic>))
            .toList(),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'from_rating': fromRating,
        'to_rating': toRating,
        'rungs': rungs
            .map((r) => LadderRungModel(
                  problemId: r.problemId,
                  rating: r.rating,
                  solved: r.solved,
                  topicId: r.topicId,
                ).toJson())
            .toList(),
      };
}
