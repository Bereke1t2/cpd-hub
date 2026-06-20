import '../../domain/entity/lesson_entity.dart';

class LessonModel extends LessonEntity {
  const LessonModel({
    required super.topicId,
    required super.body,
    required super.keyIdeas,
  });

  factory LessonModel.fromJson(Map<String, dynamic> j) => LessonModel(
        topicId: (j['topic_id'] ?? '') as String,
        body: (j['body'] ?? '') as String,
        keyIdeas: List<String>.from(j['key_ideas'] ?? []),
      );

  Map<String, dynamic> toJson() => {
        'topic_id': topicId,
        'body': body,
        'key_ideas': keyIdeas,
      };
}
