import '../../domain/entity/lesson_entity.dart';

class LessonModel extends LessonEntity {
  const LessonModel({
    required super.topicId,
    required super.body,
    required super.keyIdeas,
    super.videos,
  });

  factory LessonModel.fromJson(Map<String, dynamic> j) => LessonModel(
        topicId: (j['topic_id'] ?? '') as String,
        body: (j['body'] ?? '') as String,
        keyIdeas: List<String>.from(j['key_ideas'] ?? []),
        videos: ((j['videos'] ?? []) as List)
            .map((v) => LessonVideo(
                  title: (v['title'] ?? '') as String,
                  url: (v['url'] ?? '') as String,
                  durationLabel: v['duration'] as String?,
                ))
            .toList(),
      );

  Map<String, dynamic> toJson() => {
        'topic_id': topicId,
        'body': body,
        'key_ideas': keyIdeas,
        'videos': videos
            .map((v) => {
                  'title': v.title,
                  'url': v.url,
                  if (v.durationLabel != null) 'duration': v.durationLabel,
                })
            .toList(),
      };
}
