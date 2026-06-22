import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lab_portal/core/theme/app_dimens.dart';
import 'package:lab_portal/core/ui_constants.dart';
import 'package:lab_portal/features/courses/domain/entity/lesson_entity.dart';
import 'package:lab_portal/features/courses/presentation/bloc/course_detail/course_detail_bloc.dart';
import 'package:lab_portal/features/courses/presentation/widget/article_view.dart';
import 'package:lab_portal/features/courses/presentation/widget/pdf_view.dart';
import 'package:lab_portal/features/courses/presentation/widget/video_player_view.dart';

class LessonPage extends StatefulWidget {
  final LessonEntity lesson;
  final String courseId;

  const LessonPage({super.key, required this.lesson, required this.courseId});

  @override
  State<LessonPage> createState() => _LessonPageState();
}

class _LessonPageState extends State<LessonPage> {
  double _readProgress = 0;
  bool _completed = false;

  @override
  void initState() {
    super.initState();
    _completed = widget.lesson.completed;
  }

  LessonEntity get lesson => widget.lesson;

  ({IconData icon, String label}) get _kind {
    switch (lesson.kind) {
      case LessonKind.video:
        return (icon: Icons.play_circle_outline_rounded, label: 'Video lesson');
      case LessonKind.article:
        return (icon: Icons.article_outlined, label: 'Article');
      case LessonKind.pdf:
        return (icon: Icons.picture_as_pdf_outlined, label: 'PDF');
    }
  }

  void _markComplete() {
    context
        .read<CourseDetailBloc>()
        .add(CourseDetailLessonCompleted(widget.courseId, lesson.id));
    setState(() => _completed = true);
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        const SnackBar(
          content: Text('Lesson complete! 🎉'),
          backgroundColor: UiConstants.primaryButtonColor,
          behavior: SnackBarBehavior.floating,
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: UiConstants.backgroundColor,
      body: Column(
        children: [
          _Header(
            title: lesson.title,
            kindIcon: _kind.icon,
            kindLabel: _kind.label,
            duration: lesson.duration,
            completed: _completed,
            progress: lesson.kind == LessonKind.article ? _readProgress : null,
            onBack: () => Navigator.pop(context),
          ),
          Expanded(child: _content()),
        ],
      ),
      bottomNavigationBar: _CompleteBar(
        completed: _completed,
        visible: lesson.kind != LessonKind.pdf,
        onComplete: _markComplete,
      ),
    );
  }

  Widget _content() {
    switch (lesson.kind) {
      case LessonKind.video:
        return _VideoBody(
          lesson: lesson,
          onComplete: () {
            if (!_completed) _markComplete();
          },
        );
      case LessonKind.article:
        return ArticleView(
          markdown: lesson.inlineText ?? '*No content available.*',
          onProgress: (p) {
            if ((p - _readProgress).abs() > 0.01) {
              setState(() => _readProgress = p);
            }
          },
          onComplete: () {
            if (!_completed) _markComplete();
          },
        );
      case LessonKind.pdf:
        return PdfView(url: lesson.contentUrl, onComplete: _markComplete);
    }
  }
}

// ── Gradient header with optional reading-progress bar ────────────────────────
class _Header extends StatelessWidget {
  final String title;
  final IconData kindIcon;
  final String kindLabel;
  final Duration? duration;
  final bool completed;
  final double? progress; // null for non-article lessons
  final VoidCallback onBack;

  const _Header({
    required this.title,
    required this.kindIcon,
    required this.kindLabel,
    required this.duration,
    required this.completed,
    required this.progress,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    final meta = StringBuffer(kindLabel);
    if (duration != null) meta.write('  ·  ${duration!.inMinutes} min');

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [UiConstants.primaryDark, UiConstants.backgroundColor],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(
                  AppDimens.sm, AppDimens.sm, AppDimens.lg, AppDimens.md),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: onBack,
                    icon: const Icon(Icons.arrow_back_rounded,
                        color: Colors.white),
                    splashRadius: 22,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(kindIcon,
                                size: 13,
                                color: Colors.white.withValues(alpha: 0.85)),
                            const SizedBox(width: AppDimens.xs),
                            // Flexible + ellipsis so a long kind/duration label
                            // can never overflow the header row.
                            Flexible(
                              child: Text(
                                meta.toString().toUpperCase(),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: Colors.white.withValues(alpha: 0.85),
                                  fontSize: AppDimens.fMicro,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: 0.6,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppDimens.xxs),
                        Text(
                          title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: AppDimens.fH1,
                            fontWeight: FontWeight.w800,
                            height: 1.2,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (completed)
                    const Padding(
                      padding: EdgeInsets.only(left: AppDimens.sm),
                      child: Icon(Icons.check_circle_rounded,
                          color: Colors.white, size: AppDimens.iconLg),
                    ),
                ],
              ),
            ),
            if (progress != null)
              LinearProgressIndicator(
                value: progress,
                minHeight: 3,
                backgroundColor: Colors.white.withValues(alpha: 0.15),
                valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
              ),
          ],
        ),
      ),
    );
  }
}

// ── Video lesson: framed player + info below ──────────────────────────────────
class _VideoBody extends StatelessWidget {
  final LessonEntity lesson;
  final VoidCallback onComplete;

  const _VideoBody({
    required this.lesson,
    required this.onComplete,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Framed player.
          Padding(
            padding: const EdgeInsets.fromLTRB(
                AppDimens.lg, AppDimens.md, AppDimens.lg, 0),
            child: Container(
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                borderRadius: AppDimens.brMd,
                color: Colors.black,
                border: Border.all(
                    color: UiConstants.primaryButtonColor
                        .withValues(alpha: 0.20)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.35),
                    blurRadius: 16,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: VideoPlayerView(
                url: lesson.contentUrl,
                onComplete: onComplete,
              ),
            ),
          ),
          // Title and duration already live in the header — keep the body to a
          // calm overview so nothing is repeated on screen.
          Padding(
            padding: const EdgeInsets.all(AppDimens.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'ABOUT THIS LESSON',
                  style: TextStyle(
                    color: UiConstants.primaryButtonColor
                        .withValues(alpha: 0.9),
                    fontSize: AppDimens.fMicro,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.0,
                  ),
                ),
                const SizedBox(height: AppDimens.sm),
                const Text(
                  'Watch the lesson all the way through, then mark it complete '
                  'to track your progress through the course.',
                  style: TextStyle(
                    color: UiConstants.subtitleTextColor,
                    fontSize: AppDimens.fBody,
                    height: 1.6,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Bottom complete bar ───────────────────────────────────────────────────────
class _CompleteBar extends StatelessWidget {
  final bool completed;
  final bool visible;
  final VoidCallback onComplete;

  const _CompleteBar({
    required this.completed,
    required this.visible,
    required this.onComplete,
  });

  @override
  Widget build(BuildContext context) {
    if (!visible) return const SizedBox.shrink();
    return SafeArea(
      minimum: const EdgeInsets.all(AppDimens.md),
      child: completed
          ? Container(
              height: AppDimens.buttonHeight,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: UiConstants.primaryButtonColor.withValues(alpha: 0.12),
                borderRadius: AppDimens.brMd,
                border: Border.all(
                    color: UiConstants.primaryButtonColor
                        .withValues(alpha: 0.4)),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.check_circle_rounded,
                      color: UiConstants.primaryButtonColor,
                      size: AppDimens.iconMd),
                  SizedBox(width: AppDimens.sm),
                  Text('Completed',
                      style: TextStyle(
                        color: UiConstants.primaryButtonColor,
                        fontWeight: FontWeight.w800,
                        fontSize: AppDimens.fTitle,
                      )),
                ],
              ),
            )
          : SizedBox(
              height: AppDimens.buttonHeight,
              child: FilledButton.icon(
                onPressed: onComplete,
                style: FilledButton.styleFrom(
                  backgroundColor: UiConstants.primaryButtonColor,
                  foregroundColor: Colors.white,
                  shape: const RoundedRectangleBorder(
                      borderRadius: AppDimens.brMd),
                ),
                icon: const Icon(Icons.check_circle_outline_rounded,
                    size: AppDimens.iconSm),
                label: const Text('Mark as complete',
                    style: TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: AppDimens.fTitle)),
              ),
            ),
    );
  }
}
