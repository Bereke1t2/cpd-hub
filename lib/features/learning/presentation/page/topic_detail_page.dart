import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lab_portal/core/di/injection.dart';
import 'package:lab_portal/core/theme/app_colors.dart';
import 'package:lab_portal/core/theme/app_dimens.dart';
import 'package:lab_portal/core/theme/app_text_styles.dart';
import 'package:lab_portal/core/ui_constants.dart';
import 'package:lab_portal/core/widgets/ui_kit.dart';
import 'package:lab_portal/future/main/domain/entity/problem_entity.dart';
import 'package:lab_portal/future/main/presentation/bloc/problems/problems_bloc.dart';
import 'package:lab_portal/future/main/presentation/page/problem_details_page.dart';
import '../../domain/entity/lesson_entity.dart';
import '../../domain/entity/topic_entity.dart';
import '../../domain/service/learning_path_engine.dart';
import '../../domain/usecase/get_lesson.dart';
import '../widget/lesson_video_card.dart';
import '../widget/topic_node.dart';

class TopicDetailPage extends StatefulWidget {
  final TopicEntity topic;
  final TopicProgress progress;
  final Map<String, TopicProgress> allProgress;

  const TopicDetailPage({
    super.key,
    required this.topic,
    required this.progress,
    required this.allProgress,
  });

  @override
  State<TopicDetailPage> createState() => _TopicDetailPageState();
}

class _TopicDetailPageState extends State<TopicDetailPage> {
  LessonEntity? _lesson;
  bool _loadingLesson = true;

  TopicEntity get topic => widget.topic;
  TopicProgress get progress => widget.progress;

  @override
  void initState() {
    super.initState();
    _loadLesson();
  }

  Future<void> _loadLesson() async {
    final result = await getIt<GetLesson>().call(topic.id);
    if (!mounted) return;
    setState(() {
      result.fold((l) => _lesson = l, (_) => null);
      _loadingLesson = false;
    });
  }

  // One spacing rhythm for every section so the page reads as a single surface.
  static const EdgeInsets _sectionPad =
      EdgeInsets.fromLTRB(AppDimens.lg, AppDimens.md, AppDimens.lg, 0);

  @override
  Widget build(BuildContext context) {
    final style = TopicStatusStyle.of(progress.status);
    final lesson = _lesson;

    return Scaffold(
      backgroundColor: UiConstants.backgroundColor,
      appBar: AppBar(
        backgroundColor: UiConstants.infoBackgroundColor,
        foregroundColor: UiConstants.mainTextColor,
        elevation: 0,
        title: Text(
          topic.name,
          style: AppTextStyles.title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
      body: CustomScrollView(
        slivers: [
          // ── Header: progress + meta + status ──────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: _sectionPad,
              child: GradientCard(
                child: Row(
                  children: [
                    ProgressRing(
                      ratio: progress.ratio,
                      size: 56,
                      stroke: 6,
                      color: UiConstants.primaryButtonColor,
                      center: Text(
                        '${progress.solved}/${progress.total}',
                        style: AppTextStyles.caption.copyWith(
                          color: UiConstants.primaryButtonColor,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                    const SizedBox(width: AppDimens.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(topic.category, style: AppTextStyles.caption),
                          const SizedBox(height: AppDimens.xxs),
                          Text(
                            topic.name,
                            style: AppTextStyles.title,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: AppDimens.sm),
                          // Wrap keeps the pills on screen no matter the width.
                          Wrap(
                            spacing: AppDimens.sm,
                            runSpacing: AppDimens.xs,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: [
                              StatPill(
                                'Level',
                                '${topic.difficulty} / 5',
                                color: UiConstants.primaryButtonColor,
                              ),
                              StatusChip(
                                label: style.label,
                                icon: style.icon,
                                color: style.color,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // ── About ─────────────────────────────────────────────────────────
          _section(
            child: GradientCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SectionHeader('About',
                      icon: Icons.info_outline_rounded),
                  const SizedBox(height: AppDimens.xs),
                  Text(topic.summary, style: AppTextStyles.body),
                ],
              ),
            ),
          ),

          // ── Concept ───────────────────────────────────────────────────────
          if (!_loadingLesson && lesson != null)
            _section(child: _ConceptCard(lesson: lesson)),

          // ── Videos (between concept and practice) ─────────────────────────
          if (!_loadingLesson && lesson != null && lesson.videos.isNotEmpty)
            SliverToBoxAdapter(
              child: Padding(
                padding: _sectionPad,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SectionHeader('Watch',
                        icon: Icons.smart_display_outlined),
                    for (final v in lesson.videos)
                      Padding(
                        padding: const EdgeInsets.only(bottom: AppDimens.sm),
                        child: LessonVideoCard(video: v),
                      ),
                  ],
                ),
              ),
            ),

          // ── References ────────────────────────────────────────────────────
          if (topic.referenceUrls.isNotEmpty)
            _section(
              child: GradientCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SectionHeader('References',
                        icon: Icons.link_rounded),
                    const SizedBox(height: AppDimens.xs),
                    for (final url in topic.referenceUrls)
                      Padding(
                        padding: const EdgeInsets.only(bottom: AppDimens.xs),
                        child: Row(
                          children: [
                            const Icon(Icons.open_in_new_rounded,
                                size: AppDimens.iconSm,
                                color: UiConstants.primaryButtonColor),
                            const SizedBox(width: AppDimens.sm),
                            Expanded(
                              child: Text(
                                url,
                                style: AppTextStyles.caption.copyWith(
                                  color: UiConstants.primaryButtonColor,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ),

          // ── Practice ──────────────────────────────────────────────────────
          _section(
            child: _PracticeSection(topic: topic, progress: progress),
          ),

          // ── Prerequisites ─────────────────────────────────────────────────
          if (topic.prerequisiteIds.isNotEmpty)
            _section(
              child: GradientCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SectionHeader('Prerequisites',
                        icon: Icons.lock_open_rounded),
                    const SizedBox(height: AppDimens.xs),
                    Wrap(
                      spacing: AppDimens.xs,
                      runSpacing: AppDimens.xs,
                      children: topic.prerequisiteIds.map((pid) {
                        final pProg = widget.allProgress[pid];
                        final pStyle = TopicStatusStyle.of(
                          pProg?.status ?? TopicStatus.locked,
                        );
                        return StatusChip(
                          label: pid
                              .replaceAll('-', ' ')
                              .split(' ')
                              .map((w) => w.isNotEmpty
                                  ? '${w[0].toUpperCase()}${w.substring(1)}'
                                  : '')
                              .join(' '),
                          icon: pStyle.icon,
                          color: pStyle.color,
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ),

          const SliverToBoxAdapter(child: SizedBox(height: AppDimens.xl)),
        ],
      ),
    );
  }

  // Wraps any section child in the shared padding rhythm.
  Widget _section({required Widget child}) => SliverToBoxAdapter(
        child: Padding(padding: _sectionPad, child: child),
      );
}

// ── Concept (lesson body + key ideas) ─────────────────────────────────────────
class _ConceptCard extends StatelessWidget {
  final LessonEntity lesson;
  const _ConceptCard({required this.lesson});

  @override
  Widget build(BuildContext context) {
    return GradientCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeader('Concept',
              icon: Icons.lightbulb_outline_rounded),
          const SizedBox(height: AppDimens.xs),
          Text(lesson.body, style: AppTextStyles.body),
          if (lesson.keyIdeas.isNotEmpty) ...[
            const SizedBox(height: AppDimens.sm),
            const Divider(color: UiConstants.borderColor),
            const SizedBox(height: AppDimens.xs),
            for (final idea in lesson.keyIdeas)
              Padding(
                padding: const EdgeInsets.only(bottom: AppDimens.xs),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('•  ',
                        style: TextStyle(
                            color: UiConstants.primaryButtonColor,
                            fontWeight: FontWeight.w900)),
                    Expanded(child: Text(idea, style: AppTextStyles.body)),
                  ],
                ),
              ),
          ],
        ],
      ),
    );
  }
}

// ── Practice problems ─────────────────────────────────────────────────────────
class _PracticeSection extends StatelessWidget {
  final TopicEntity topic;
  final TopicProgress progress;

  const _PracticeSection({required this.topic, required this.progress});

  @override
  Widget build(BuildContext context) {
    if (topic.problemIds.isEmpty) {
      return GradientCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SectionHeader('Practice',
                icon: Icons.code_rounded, trailing: '0 problems'),
            const SizedBox(height: AppDimens.xs),
            const Text('Problems coming soon.', style: AppTextStyles.body),
          ],
        ),
      );
    }

    // Read problems from the ambient ProblemsBloc (provided higher up in the tree).
    final problemsState = context.watch<ProblemsBloc>().state;
    List<ProblemEntity> allProblems = [];
    if (problemsState is ProblemsLoaded) {
      allProblems = problemsState.problems;
    }
    final mapped = topic.problemIds
        .map((id) {
          try {
            return allProblems.firstWhere((p) => p.problemId == id);
          } catch (_) {
            return null;
          }
        })
        .whereType<ProblemEntity>()
        .toList();

    return GradientCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionHeader(
            'Practice',
            icon: Icons.code_rounded,
            trailing: '${progress.solved}/${progress.total}',
          ),
          const SizedBox(height: AppDimens.xs),
          if (mapped.isEmpty)
            Text(
              topic.problemIds.map((id) => '• $id').join('\n'),
              style: AppTextStyles.caption,
            )
          else
            for (final p in mapped) _ProblemRow(problem: p),
        ],
      ),
    );
  }
}

class _ProblemRow extends StatelessWidget {
  final ProblemEntity problem;
  const _ProblemRow({required this.problem});

  @override
  Widget build(BuildContext context) {
    final color = problem.isSolved
        ? UiConstants.primaryButtonColor
        : UiConstants.subtitleTextColor;
    return InkWell(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ProblemDetailsPage(problem: problem),
        ),
      ),
      borderRadius: AppDimens.brSm,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppDimens.sm),
        child: Row(
          children: [
            Icon(
              problem.isSolved
                  ? Icons.check_circle_rounded
                  : Icons.radio_button_unchecked_rounded,
              size: AppDimens.iconMd,
              color: color,
            ),
            const SizedBox(width: AppDimens.sm),
            Expanded(
              child: Text(problem.title,
                  style: AppTextStyles.body,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis),
            ),
            const SizedBox(width: AppDimens.sm),
            Text(problem.difficulty,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.difficulty(problem.difficulty),
                  fontWeight: FontWeight.w700,
                )),
          ],
        ),
      ),
    );
  }
}
