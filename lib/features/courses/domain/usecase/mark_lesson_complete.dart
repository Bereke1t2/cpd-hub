import 'package:dartz/dartz.dart';
import 'package:lab_portal/core/failure.dart';
import '../repository/courses_repository.dart';

class MarkLessonComplete {
  final CoursesRepository repo;
  MarkLessonComplete(this.repo);
  Future<Either<Unit, Failure>> call(String courseId, String lessonId) =>
      repo.markLessonComplete(courseId, lessonId);
}
