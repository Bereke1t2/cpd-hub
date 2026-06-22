part of 'courses_bloc.dart';

@immutable
sealed class CoursesState {
  const CoursesState();
}

final class CoursesInitial extends CoursesState {
  const CoursesInitial();
}

final class CoursesLoading extends CoursesState {
  const CoursesLoading();
}

final class CoursesLoaded extends CoursesState {
  final List<CourseEntity> courses;
  const CoursesLoaded({required this.courses});
}

final class CoursesError extends CoursesState {
  final String message;
  const CoursesError(this.message);
}
