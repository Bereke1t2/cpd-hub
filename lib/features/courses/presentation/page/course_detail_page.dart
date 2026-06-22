import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lab_portal/core/di/injection.dart';
import 'package:lab_portal/core/theme/app_dimens.dart';
import 'package:lab_portal/core/ui_constants.dart';
import 'package:lab_portal/core/widgets/app_chip.dart';
import 'package:lab_portal/core/widgets/app_text.dart';
import 'package:lab_portal/core/widgets/async_view.dart';
import 'package:lab_portal/core/widgets/ui_kit.dart';
import 'package:lab_portal/features/courses/domain/entity/course_entity.dart';
import 'package:lab_portal/features/courses/domain/entity/lesson_entity.dart';
import 'package:lab_portal/features/courses/domain/entity/module_entity.dart';
import 'package:lab_portal/features/courses/presentation/bloc/course_detail/course_detail_bloc.dart';
import 'lesson_page.dart';

class CourseDetailPage extends StatelessWidget {
  final String courseId;
  const CourseDetailPage({super.key, required this.courseId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<CourseDetailBloc>()
        ..add(CourseDetailStarted(courseId)),
      child: Scaffold(
        backgroundColor: UiConstants.backgroundColor,
        body: BlocBuilder<CourseDetailBloc, CourseDetailState>(
          builder: (context, state) => AsyncView<CourseEntity>(
            isLoading: state is CourseDetailLoading ||
                state is CourseDetailInitial,
            error:
                state is CourseDetailError ? state.message : null,
            data: state is CourseDetailLoaded ? state.course : null,
            onRetry: () => context
                .read<CourseDetailBloc>()
                .add(CourseDetailStarted(courseId)),
            emptyMessage: 'Course not found',
            builder: (course) => _CourseDetailBody(course: course),
          ),
        ),
      ),
    );
  }
}

class _CourseDetailBody extends StatelessWidget {
  final CourseEntity course;
  const _CourseDetailBody({required this.course});

  @override
  Widget build(BuildContext context) {
    final pct = (course.progress * 100).round();
    final next = course.nextLesson;

    return CustomScrollView(
      slivers: [
        // ── Hero header ────────────────────────────────────────────────
        SliverAppBar(
          expandedHeight: 200,
          backgroundColor: UiConstants.primaryDark,
          foregroundColor: Colors.white,
          flexibleSpace: FlexibleSpaceBar(
            background: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    UiConstants.primaryButtonColor,
                    UiConstants.primaryDark,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(AppDimens.lg),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      AppText.hero(course.title,
                          color: Colors.white),
                      const SizedBox(height: AppDimens.xs),
                      AppText.body(course.summary,
                          color: Colors.white70),
                      const SizedBox(height: AppDimens.md),
                      Row(
                        children: [
                          Expanded(
                            child: ClipRRect(
                              borderRadius: AppDimens.brSm,
                              child: LinearProgressIndicator(
                                value: course.progress,
                                minHeight: 6,
                                backgroundColor:
                                    Colors.white.withValues(alpha: 0.25),
                                valueColor:
                                    const AlwaysStoppedAnimation<Color>(
                                        Colors.white),
                              ),
                            ),
                          ),
                          const SizedBox(width: AppDimens.md),
                          Text(
                            '$pct%',
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w900,
                                fontSize: AppDimens.fTitle),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),

        // ── Continue button (if not finished) ─────────────────────────
        if (next != null)
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                  AppDimens.lg, AppDimens.lg, AppDimens.lg, 0),
              child: GestureDetector(
                onTap: () => _openLesson(context, next),
                child: Container(
                  padding: const EdgeInsets.all(AppDimens.md),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [
                        UiConstants.primaryButtonColor,
                        UiConstants.primaryDark,
                      ],
                    ),
                    borderRadius: AppDimens.brMd,
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.play_arrow_rounded,
                          color: Colors.white,
                          size: AppDimens.iconLg),
                      const SizedBox(width: AppDimens.sm),
                      Expanded(
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          children: [
                            const Text('Continue',
                                style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: AppDimens.fCaption,
                                    fontWeight: FontWeight.w700)),
                            AppText.title(next.title,
                                color: Colors.white,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

        // ── Module list ────────────────────────────────────────────────
        SliverPadding(
          padding: const EdgeInsets.all(AppDimens.lg),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, i) => _ModuleTile(
                module: course.modules[i],
                courseId: course.id,
              ),
              childCount: course.modules.length,
            ),
          ),
        ),
      ],
    );
  }

  void _openLesson(BuildContext context, LessonEntity lesson) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BlocProvider.value(
          value: context.read<CourseDetailBloc>(),
          child: LessonPage(
            lesson: lesson,
            courseId:
                (context.read<CourseDetailBloc>().state as CourseDetailLoaded)
                    .course
                    .id,
          ),
        ),
      ),
    );
  }
}

class _ModuleTile extends StatefulWidget {
  final ModuleEntity module;
  final String courseId;
  const _ModuleTile({required this.module, required this.courseId});

  @override
  State<_ModuleTile> createState() => _ModuleTileState();
}

class _ModuleTileState extends State<_ModuleTile> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final done = widget.module.completedCount;
    final total = widget.module.lessons.length;

    return Padding(
      padding: const EdgeInsets.only(bottom: AppDimens.md),
      child: Container(
        decoration: BoxDecoration(
          color: UiConstants.infoBackgroundColor,
          borderRadius: AppDimens.brMd,
          border: Border.all(
              color: UiConstants.primaryButtonColor.withValues(alpha: 0.18)),
        ),
        child: Column(
          children: [
            InkWell(
              onTap: () => setState(() => _expanded = !_expanded),
              borderRadius: AppDimens.brMd,
              child: Padding(
                padding: const EdgeInsets.all(AppDimens.md),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AppText.title(widget.module.title),
                          AppText.caption('$done / $total lessons',
                              color: done == total
                                  ? UiConstants.primaryButtonColor
                                  : UiConstants.subtitleTextColor),
                        ],
                      ),
                    ),
                    ProgressRing(
                      ratio: widget.module.progress,
                      size: 36,
                      stroke: 4,
                      center: Text(
                        '${(widget.module.progress * 100).round()}%',
                        style: const TextStyle(
                            fontSize: 8,
                            fontWeight: FontWeight.w800,
                            color: UiConstants.mainTextColor),
                      ),
                    ),
                    const SizedBox(width: AppDimens.sm),
                    Icon(
                      _expanded
                          ? Icons.keyboard_arrow_up_rounded
                          : Icons.keyboard_arrow_down_rounded,
                      color: UiConstants.subtitleTextColor,
                    ),
                  ],
                ),
              ),
            ),
            if (_expanded)
              ...widget.module.lessons.map((lesson) => _LessonRow(
                    lesson: lesson,
                    courseId: widget.courseId,
                  )),
          ],
        ),
      ),
    );
  }
}

class _LessonRow extends StatelessWidget {
  final LessonEntity lesson;
  final String courseId;
  const _LessonRow({required this.lesson, required this.courseId});

  IconData get _kindIcon {
    switch (lesson.kind) {
      case LessonKind.video:
        return Icons.play_circle_outline_rounded;
      case LessonKind.article:
        return Icons.article_outlined;
      case LessonKind.pdf:
        return Icons.picture_as_pdf_outlined;
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => BlocProvider.value(
            value: context.read<CourseDetailBloc>(),
            child: LessonPage(lesson: lesson, courseId: courseId),
          ),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
            AppDimens.md, AppDimens.sm, AppDimens.md, AppDimens.sm),
        child: Row(
          children: [
            Icon(_kindIcon,
                size: AppDimens.iconMd,
                color: lesson.completed
                    ? UiConstants.primaryButtonColor
                    : UiConstants.subtitleTextColor),
            const SizedBox(width: AppDimens.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText.body(lesson.title,
                      maxLines: 1, overflow: TextOverflow.ellipsis),
                  if (lesson.duration != null)
                    AppText.caption(
                        '${lesson.duration!.inMinutes}m',
                        color: UiConstants.subtitleTextColor),
                ],
              ),
            ),
            if (lesson.completed)
              const Icon(Icons.check_circle_rounded,
                  color: UiConstants.primaryButtonColor,
                  size: AppDimens.iconMd)
            else
              AppChip(
                lesson.kind.name,
                color: UiConstants.primaryButtonColor,
              ),
          ],
        ),
      ),
    );
  }
}
