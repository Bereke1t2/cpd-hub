import 'package:dartz/dartz.dart';
import 'package:lab_portal/core/failure.dart';
import '../entity/course_entity.dart';

abstract class CoursesRepository {
  Future<Either<List<CourseEntity>, Failure>> getCourses();
  Future<Either<CourseEntity, Failure>> getCourseDetail(String courseId);
  Future<Either<Unit, Failure>> markLessonComplete(
      String courseId, String lessonId);
}
