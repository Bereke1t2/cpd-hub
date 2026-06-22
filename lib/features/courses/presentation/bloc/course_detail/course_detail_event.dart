part of 'course_detail_bloc.dart';

@immutable
sealed class CourseDetailEvent {}

final class CourseDetailStarted extends CourseDetailEvent {
  final String courseId;
  CourseDetailStarted(this.courseId);
}

final class CourseDetailLessonCompleted extends CourseDetailEvent {
  final String courseId;
  final String lessonId;
  CourseDetailLessonCompleted(this.courseId, this.lessonId);
}
