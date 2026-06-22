import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lab_portal/core/theme/app_dimens.dart';
import 'package:lab_portal/core/ui_constants.dart';
import 'package:lab_portal/core/widgets/primary_button.dart';
import 'package:lab_portal/features/courses/domain/entity/lesson_entity.dart';
import 'package:lab_portal/features/courses/presentation/bloc/course_detail/course_detail_bloc.dart';
import 'package:lab_portal/features/courses/presentation/widget/article_view.dart';
import 'package:lab_portal/features/courses/presentation/widget/pdf_view.dart';
import 'package:lab_portal/features/courses/presentation/widget/video_player_view.dart';

class LessonPage extends StatelessWidget {
  final LessonEntity lesson;
  final String courseId;

  const LessonPage(
      {super.key, required this.lesson, required this.courseId});

  void _markComplete(BuildContext context) {
    context
        .read<CourseDetailBloc>()
        .add(CourseDetailLessonCompleted(courseId, lesson.id));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Lesson marked as complete! 🎉'),
        backgroundColor: UiConstants.primaryButtonColor,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Widget _body(BuildContext context) {
    switch (lesson.kind) {
      case LessonKind.video:
        return VideoPlayerView(
          url: lesson.contentUrl,
          onComplete: () => _markComplete(context),
        );
      case LessonKind.article:
        return ArticleView(
          markdown: lesson.inlineText ?? '*No content available.*',
          onComplete: () => _markComplete(context),
        );
      case LessonKind.pdf:
        return PdfView(
          url: lesson.contentUrl,
          onComplete: () => _markComplete(context),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: UiConstants.backgroundColor,
      appBar: AppBar(
        backgroundColor: UiConstants.primaryDark,
        foregroundColor: Colors.white,
        title: Text(
          lesson.title,
          style: const TextStyle(
              fontSize: AppDimens.fTitle,
              fontWeight: FontWeight.w800),
          overflow: TextOverflow.ellipsis,
        ),
        actions: [
          if (!lesson.completed)
            TextButton.icon(
              onPressed: () => _markComplete(context),
              icon: const Icon(Icons.check, color: Colors.white),
              label: const Text('Done',
                  style: TextStyle(color: Colors.white)),
            ),
          if (lesson.completed)
            const Padding(
              padding: EdgeInsets.only(right: AppDimens.md),
              child: Icon(Icons.check_circle_rounded,
                  color: UiConstants.primaryButtonColor),
            ),
        ],
      ),
      body: _body(context),
      bottomNavigationBar: lesson.kind != LessonKind.pdf && !lesson.completed
          ? SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(AppDimens.md),
                child: PrimaryButton(
                  title: 'Mark as complete',
                  icon: Icons.check_circle_outline,
                  onPressed: () {
                    _markComplete(context);
                    Navigator.pop(context);
                  },
                ),
              ),
            )
          : null,
    );
  }
}
