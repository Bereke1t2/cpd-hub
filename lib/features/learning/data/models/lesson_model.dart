import '../../domain/entity/lesson_entity.dart';

class LessonModel extends LessonEntity {
  const LessonModel({
    required super.topicId,
    required super.body,
    required super.keyIdeas,
    super.videos,
    super.code,
    super.codeLang,
  });

  factory LessonModel.fromJson(Map<String, dynamic> j) => LessonModel(
        topicId: (j['topic_id'] ?? '') as String,
        body: (j['body'] ?? '') as String,
        keyIdeas: List<String>.from(j['key_ideas'] ?? []),
        code: j['code'] as String?,
        codeLang: j['code_lang'] as String?,
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
        if (code != null) 'code': code,
        if (codeLang != null) 'code_lang': codeLang,
        'videos': videos
            .map((v) => {
                  'title': v.title,
                  'url': v.url,
                  if (v.durationLabel != null) 'duration': v.durationLabel,
                })
            .toList(),
      };
}
