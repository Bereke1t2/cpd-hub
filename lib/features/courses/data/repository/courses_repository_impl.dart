import 'package:dartz/dartz.dart';
import 'package:lab_portal/core/failure.dart';
import 'package:lab_portal/features/courses/data/datasources/courses_data_source.dart';
import 'package:lab_portal/features/courses/domain/entity/course_entity.dart';
import 'package:lab_portal/features/courses/domain/repository/courses_repository.dart';

class CoursesRepositoryImpl implements CoursesRepository {
  final CoursesDataSource dataSource;
  CoursesRepositoryImpl({required this.dataSource});

  @override
  Future<Either<List<CourseEntity>, Failure>> getCourses() async {
    try {
      final courses = await dataSource.getCourses();
      return Left(courses);
    } catch (e) {
      return Right(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<CourseEntity, Failure>> getCourseDetail(
      String courseId) async {
    try {
      final course = await dataSource.getCourseDetail(courseId);
      return Left(course);
    } catch (e) {
      return Right(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Unit, Failure>> markLessonComplete(
      String courseId, String lessonId) async {
    try {
      await dataSource.markLessonComplete(courseId, lessonId);
      return const Left(unit);
    } catch (e) {
      return Right(ServerFailure(e.toString()));
    }
  }
}
