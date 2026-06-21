import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lab_portal/core/di/injection.dart';
import 'package:lab_portal/core/theme/app_colors.dart';
import 'package:lab_portal/core/theme/app_dimens.dart';
import 'package:lab_portal/core/ui_constants.dart';
import 'package:lab_portal/core/widgets/app_card.dart';
import 'package:lab_portal/core/widgets/app_chip.dart';
import 'package:lab_portal/core/widgets/app_text.dart';
import 'package:lab_portal/core/widgets/async_view.dart';
import 'package:lab_portal/features/courses/domain/entity/course_entity.dart';
import 'package:lab_portal/features/courses/presentation/bloc/courses/courses_bloc.dart';
import 'package:lab_portal/future/main/presentation/page/base_page.dart';
import 'course_detail_page.dart';

class CoursesPage extends StatelessWidget {
  const CoursesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<CoursesBloc>()..add(CoursesStarted()),
      child: BasePage(
        title: 'Courses',
        subtitle: 'Structured video & text learning',
        selectedIndex: 2,
        body: BlocBuilder<CoursesBloc, CoursesState>(
          builder: (context, state) => AsyncView<List<CourseEntity>>(
            isLoading:
                state is CoursesLoading || state is CoursesInitial,
            error: state is CoursesError ? state.message : null,
            data: state is CoursesLoaded ? state.courses : null,
            isEmpty: (d) => d.isEmpty,
            onRetry: () =>
                context.read<CoursesBloc>().add(CoursesStarted()),
            emptyMessage: 'No courses yet',
            builder: (courses) => ListView.builder(
              padding: const EdgeInsets.all(AppDimens.md),
              itemCount: courses.length,
              itemBuilder: (context, i) => Padding(
                padding: const EdgeInsets.only(bottom: AppDimens.md),
                child: _CourseCard(
                  course: courses[i],
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          CourseDetailPage(courseId: courses[i].id),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _CourseCard extends StatelessWidget {
  final CourseEntity course;
  final VoidCallback onTap;
  const _CourseCard({required this.course, required this.onTap});

  Color _levelColor(String level) {
    switch (level.toLowerCase()) {
      case 'beginner':
        return AppColors.difficulty('easy');
      case 'intermediate':
        return AppColors.difficulty('medium');
      case 'advanced':
        return AppColors.difficulty('hard');
      default:
        return UiConstants.primaryButtonColor;
    }
  }

  @override
  Widget build(BuildContext context) {
    final lvlColor = _levelColor(course.level);
    final pct = (course.progress * 100).round();
    return AppCard(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: AppText.h2(course.title,
                    maxLines: 2, overflow: TextOverflow.ellipsis),
              ),
              const SizedBox(width: AppDimens.sm),
              AppChip(course.level, color: lvlColor),
            ],
          ),
          const SizedBox(height: AppDimens.xs),
          AppText.body(course.summary,
              color: UiConstants.subtitleTextColor,
              maxLines: 2,
              overflow: TextOverflow.ellipsis),
          const SizedBox(height: AppDimens.md),
          Row(
            children: [
              Icon(Icons.menu_book_outlined,
                  size: AppDimens.iconSm,
                  color: UiConstants.subtitleTextColor),
              const SizedBox(width: AppDimens.xs),
              AppText.caption('${course.lessonCount} lessons'),
              const Spacer(),
              AppText.caption('$pct% complete',
                  color: pct > 0
                      ? UiConstants.primaryButtonColor
                      : UiConstants.subtitleTextColor),
            ],
          ),
          const SizedBox(height: AppDimens.sm),
          ClipRRect(
            borderRadius: AppDimens.brSm,
            child: LinearProgressIndicator(
              value: course.progress,
              minHeight: 5,
              backgroundColor:
                  UiConstants.primaryButtonColor.withValues(alpha: 0.12),
              valueColor: const AlwaysStoppedAnimation<Color>(
                  UiConstants.primaryButtonColor),
            ),
          ),
        ],
      ),
    );
  }
}
