import '../models/course_model.dart';

abstract class CoursesDataSource {
  Future<List<CourseModel>> getCourses();
  Future<CourseModel> getCourseDetail(String courseId);
  Future<void> markLessonComplete(String courseId, String lessonId);
}
