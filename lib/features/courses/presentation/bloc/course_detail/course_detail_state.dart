part of 'course_detail_bloc.dart';

@immutable
sealed class CourseDetailState {
  const CourseDetailState();
}

final class CourseDetailInitial extends CourseDetailState {
  const CourseDetailInitial();
}

final class CourseDetailLoading extends CourseDetailState {
  const CourseDetailLoading();
}

final class CourseDetailLoaded extends CourseDetailState {
  final CourseEntity course;
  const CourseDetailLoaded({required this.course});
}

final class CourseDetailError extends CourseDetailState {
  final String message;
  const CourseDetailError(this.message);
}
