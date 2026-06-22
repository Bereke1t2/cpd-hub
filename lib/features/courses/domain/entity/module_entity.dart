import 'package:equatable/equatable.dart';
import 'lesson_entity.dart';

class ModuleEntity extends Equatable {
  final String id;
  final String title;
  final List<LessonEntity> lessons;

  const ModuleEntity({
    required this.id,
    required this.title,
    required this.lessons,
  });

  double get progress => lessons.isEmpty
      ? 0
      : lessons.where((l) => l.completed).length / lessons.length;

  int get completedCount => lessons.where((l) => l.completed).length;

  @override
  List<Object?> get props => [id, title, lessons];
}
