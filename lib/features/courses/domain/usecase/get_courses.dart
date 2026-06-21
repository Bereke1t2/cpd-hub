import 'package:dartz/dartz.dart';
import 'package:lab_portal/core/failure.dart';
import '../entity/course_entity.dart';
import '../repository/courses_repository.dart';

class GetCourses {
  final CoursesRepository repo;
  GetCourses(this.repo);
  Future<Either<List<CourseEntity>, Failure>> call() => repo.getCourses();
}
