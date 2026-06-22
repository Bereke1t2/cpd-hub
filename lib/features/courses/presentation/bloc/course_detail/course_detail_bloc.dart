import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:lab_portal/features/courses/domain/entity/course_entity.dart';
import 'package:lab_portal/features/courses/domain/usecase/get_course_detail.dart';
import 'package:lab_portal/features/courses/domain/usecase/mark_lesson_complete.dart';

part 'course_detail_event.dart';
part 'course_detail_state.dart';

class CourseDetailBloc extends Bloc<CourseDetailEvent, CourseDetailState> {
  final GetCourseDetail getCourseDetail;
  final MarkLessonComplete markLessonComplete;

  CourseDetailBloc({
    required this.getCourseDetail,
    required this.markLessonComplete,
  }) : super(const CourseDetailInitial()) {
    on<CourseDetailStarted>(_onStarted);
    on<CourseDetailLessonCompleted>(_onLessonCompleted);
  }

  Future<void> _onStarted(
      CourseDetailStarted event, Emitter<CourseDetailState> emit) async {
    emit(const CourseDetailLoading());
    final result = await getCourseDetail(event.courseId);
    result.fold(
      (course) => emit(CourseDetailLoaded(course: course)),
      (failure) => emit(CourseDetailError(failure.message)),
    );
  }

  Future<void> _onLessonCompleted(CourseDetailLessonCompleted event,
      Emitter<CourseDetailState> emit) async {
    if (state is! CourseDetailLoaded) return;
    await markLessonComplete(event.courseId, event.lessonId);
    // Reload with updated progress.
    final result = await getCourseDetail(event.courseId);
    result.fold(
      (course) => emit(CourseDetailLoaded(course: course)),
      (_) {}, // keep current state on error
    );
  }
}
