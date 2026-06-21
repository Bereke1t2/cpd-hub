part of 'courses_bloc.dart';

@immutable
sealed class CoursesEvent {}

final class CoursesStarted extends CoursesEvent {}
