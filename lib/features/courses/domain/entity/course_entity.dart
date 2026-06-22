import 'package:equatable/equatable.dart';
import 'lesson_entity.dart';
import 'module_entity.dart';

class CourseEntity extends Equatable {
  final String id;
  final String title;
  final String summary;
  final String level; // Beginner / Intermediate / Advanced
  final List<ModuleEntity> modules;

  const CourseEntity({
    required this.id,
    required this.title,
    required this.summary,
    required this.level,
    required this.modules,
  });

  int get lessonCount =>
      modules.fold(0, (n, m) => n + m.lessons.length);

  List<LessonEntity> get allLessons =>
      modules.expand((m) => m.lessons).toList();

  double get progress {
    final all = allLessons;
    return all.isEmpty
        ? 0
        : all.where((l) => l.completed).length / all.length;
  }

  /// First lesson in the first module that is not completed.
  LessonEntity? get nextLesson {
    for (final m in modules) {
      for (final l in m.lessons) {
        if (!l.completed) return l;
      }
    }
    return null;
  }

  @override
  List<Object?> get props => [id, title, summary, level, modules];
}
