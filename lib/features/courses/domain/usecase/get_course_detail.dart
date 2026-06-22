import 'package:dartz/dartz.dart';
import 'package:lab_portal/core/failure.dart';
import '../entity/course_entity.dart';
import '../repository/courses_repository.dart';

class GetCourseDetail {
  final CoursesRepository repo;
  GetCourseDetail(this.repo);
  Future<Either<CourseEntity, Failure>> call(String courseId) =>
      repo.getCourseDetail(courseId);
}
