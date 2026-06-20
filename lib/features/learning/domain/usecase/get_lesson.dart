import 'package:dartz/dartz.dart';
import 'package:lab_portal/core/failure.dart';
import '../entity/lesson_entity.dart';
import '../repository/learning_repository.dart';

class GetLesson {
  final LearningRepository repo;
  GetLesson(this.repo);
  Future<Either<LessonEntity?, Failure>> call(String topicId) =>
      repo.getLesson(topicId);
}
