import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:lab_portal/features/courses/domain/entity/course_entity.dart';
import 'package:lab_portal/features/courses/domain/usecase/get_courses.dart';

part 'courses_event.dart';
part 'courses_state.dart';

class CoursesBloc extends Bloc<CoursesEvent, CoursesState> {
  final GetCourses getCourses;

  CoursesBloc({required this.getCourses}) : super(const CoursesInitial()) {
    on<CoursesStarted>(_onStarted);
  }

  Future<void> _onStarted(
      CoursesStarted event, Emitter<CoursesState> emit) async {
    emit(const CoursesLoading());
    final result = await getCourses();
    result.fold(
      (courses) => emit(CoursesLoaded(courses: courses)),
      (failure) => emit(CoursesError(failure.message)),
    );
  }
}
