import 'package:lab_portal/features/courses/domain/entity/course_entity.dart';
import 'package:lab_portal/features/courses/domain/entity/lesson_entity.dart';
import 'package:lab_portal/features/courses/domain/entity/module_entity.dart';

class LessonModel extends LessonEntity {
  const LessonModel({
    required super.id,
    required super.title,
    required super.kind,
    required super.contentUrl,
    super.inlineText,
    super.duration,
    super.completed,
  });

  factory LessonModel.fromJson(Map<String, dynamic> j,
      {bool completed = false}) {
    final kindStr = (j['kind'] as String? ?? 'article').toLowerCase();
    final kind = kindStr == 'video'
        ? LessonKind.video
        : kindStr == 'pdf'
            ? LessonKind.pdf
            : LessonKind.article;
    final durSec = j['durationSec'] as int?;
    return LessonModel(
      id: j['id'] as String,
      title: j['title'] as String,
      kind: kind,
      contentUrl: j['contentUrl'] as String? ?? '',
      inlineText: j['inlineText'] as String?,
      duration: durSec != null ? Duration(seconds: durSec) : null,
      completed: completed,
    );
  }

  LessonModel withCompleted(bool c) => LessonModel(
        id: id,
        title: title,
        kind: kind,
        contentUrl: contentUrl,
        inlineText: inlineText,
        duration: duration,
        completed: c,
      );
}

class ModuleModel extends ModuleEntity {
  const ModuleModel({
    required super.id,
    required super.title,
    required super.lessons,
  });

  factory ModuleModel.fromJson(Map<String, dynamic> j,
      Set<String> completedIds) {
    final lessons = (j['lessons'] as List<dynamic>)
        .map((l) => LessonModel.fromJson(
            l as Map<String, dynamic>,
            completed: completedIds.contains(l['id'])))
        .toList();
    return ModuleModel(
        id: j['id'] as String,
        title: j['title'] as String,
        lessons: lessons);
  }
}

class CourseModel extends CourseEntity {
  const CourseModel({
    required super.id,
    required super.title,
    required super.summary,
    required super.level,
    required super.modules,
  });

  factory CourseModel.fromJson(Map<String, dynamic> j,
      Set<String> completedIds) {
    final modules = (j['modules'] as List<dynamic>)
        .map((m) => ModuleModel.fromJson(
            m as Map<String, dynamic>, completedIds))
        .toList();
    return CourseModel(
      id: j['id'] as String,
      title: j['title'] as String,
      summary: j['summary'] as String? ?? '',
      level: j['level'] as String? ?? 'Beginner',
      modules: modules,
    );
  }
}
