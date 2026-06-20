import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lab_portal/core/di/injection.dart';
import 'package:lab_portal/core/theme/app_spacing.dart';
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
import '../widget/topic_node.dart';

class TopicDetailPage extends StatelessWidget {
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
  Widget build(BuildContext context) {
    final style = TopicStatusStyle.of(progress.status);
    return Scaffold(
      backgroundColor: UiConstants.backgroundColor,
      appBar: AppBar(
        backgroundColor: UiConstants.infoBackgroundColor,
        foregroundColor: UiConstants.mainTextColor,
        elevation: 0,
        title: Text(topic.name, style: AppTextStyles.title),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: AppSpacing.sm),
            child: StatusChip(
              label: style.label,
              icon: style.icon,
              color: style.color,
            ),
          ),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          // Header card — topic meta + progress ring.
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.md, AppSpacing.md, AppSpacing.md, 0),
              child: GradientCard(
                accent: style.color,
                child: Row(
                  children: [
                    ProgressRing(
                      ratio: progress.ratio,
                      size: 60,
                      stroke: 6,
                      color: style.color,
                      center: Text(
                        '${progress.solved}/${progress.total}',
                        style: AppTextStyles.caption.copyWith(
                          color: style.color,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(topic.category, style: AppTextStyles.caption),
                          const SizedBox(height: 2),
                          Text(topic.name, style: AppTextStyles.title),
                          const SizedBox(height: AppSpacing.xs),
                          StatPill(
                            'Level',
                            '${topic.difficulty} / 5',
                            color: UiConstants.statTextColor,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Summary.
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                  AppSpacing.md, AppSpacing.md, AppSpacing.md, 0),
              child: GradientCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SectionHeader('About', icon: Icons.info_outline_rounded),
                    const SizedBox(height: AppSpacing.xs),
                    Text(topic.summary, style: AppTextStyles.body),
                  ],
                ),
              ),
            ),
          ),

          // Lesson content.
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                  AppSpacing.md, AppSpacing.xs, AppSpacing.md, 0),
              child: _LessonSection(topicId: topic.id),
            ),
          ),

          // References.
          if (topic.referenceUrls.isNotEmpty)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                    AppSpacing.md, AppSpacing.xs, AppSpacing.md, 0),
                child: GradientCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SectionHeader('References',
                          icon: Icons.link_rounded),
                      const SizedBox(height: AppSpacing.xs),
                      for (final url in topic.referenceUrls)
                        Padding(
                          padding: const EdgeInsets.only(
                              bottom: AppSpacing.xs),
                          child: Row(
                            children: [
                              const Icon(Icons.open_in_new_rounded,
                                  size: 14,
                                  color: UiConstants.problemTextColor),
                              const SizedBox(width: 6),
                              Expanded(
                                child: Text(
                                  url,
                                  style: AppTextStyles.caption.copyWith(
                                    color: UiConstants.problemTextColor,
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
            ),

          // Practice problems.
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                  AppSpacing.md, AppSpacing.xs, AppSpacing.md, 0),
              child: _PracticeSection(
                topic: topic,
                progress: progress,
              ),
            ),
          ),

          // Prerequisites.
          if (topic.prerequisiteIds.isNotEmpty)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                    AppSpacing.md, AppSpacing.xs, AppSpacing.md, 0),
                child: GradientCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SectionHeader('Prerequisites',
                          icon: Icons.lock_open_rounded),
                      const SizedBox(height: AppSpacing.xs),
                      Wrap(
                        spacing: AppSpacing.xs,
                        runSpacing: AppSpacing.xs,
                        children: topic.prerequisiteIds.map((pid) {
                          final pProg = allProgress[pid];
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
            ),

          const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.xl)),
        ],
      ),
    );
  }
}

// Loads and renders the lesson body + key ideas.
class _LessonSection extends StatefulWidget {
  final String topicId;
  const _LessonSection({required this.topicId});

  @override
  State<_LessonSection> createState() => _LessonSectionState();
}

class _LessonSectionState extends State<_LessonSection> {
  LessonEntity? _lesson;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final result = await getIt<GetLesson>().call(widget.topicId);
    if (!mounted) return;
    setState(() {
      result.fold((l) => _lesson = l, (_) => null);
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) return const SizedBox.shrink();
    final lesson = _lesson;
    if (lesson == null) return const SizedBox.shrink();

    return GradientCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionHeader('Concept', icon: Icons.lightbulb_outline_rounded),
          const SizedBox(height: AppSpacing.xs),
          Text(lesson.body, style: AppTextStyles.body),
          if (lesson.keyIdeas.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.sm),
            const Divider(color: UiConstants.borderColor),
            const SizedBox(height: AppSpacing.xs),
            for (final idea in lesson.keyIdeas)
              Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('• ',
                        style: TextStyle(
                            color: UiConstants.primaryButtonColor,
                            fontWeight: FontWeight.w900)),
                    Expanded(
                        child: Text(idea, style: AppTextStyles.body)),
                  ],
                ),
              ),
          ],
        ],
      ),
    );
  }
}

// Shows the topic's problem set (easy→hard) with solved ticks.
// Pulls from ProblemsBloc already in tree; falls back to linking by problemId.
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
            SectionHeader(
              'Practice',
              icon: Icons.code_rounded,
              trailing: '0 problems',
            ),
            const SizedBox(height: AppSpacing.xs),
            const Text('Problems coming soon.',
                style: AppTextStyles.body),
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
          const SizedBox(height: AppSpacing.xs),
          ProgressRing(
            ratio: progress.ratio,
            size: 36,
            stroke: 4,
            color: UiConstants.primaryButtonColor,
            center: Text(
              '${(progress.ratio * 100).round()}%',
              style: const TextStyle(
                  fontSize: 9,
                  color: UiConstants.primaryButtonColor,
                  fontWeight: FontWeight.w900),
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          if (mapped.isEmpty)
            Text(
              topic.problemIds.map((id) => '• $id').join('\n'),
              style: AppTextStyles.caption,
            )
          else
            for (final p in mapped)
              _ProblemRow(problem: p),
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
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(
          children: [
            Icon(
              problem.isSolved
                  ? Icons.check_circle_rounded
                  : Icons.radio_button_unchecked_rounded,
              size: 18,
              color: color,
            ),
            const SizedBox(width: AppSpacing.xs),
            Expanded(
              child: Text(problem.title, style: AppTextStyles.body),
            ),
            Text(problem.difficulty,
                style: AppTextStyles.caption.copyWith(
                  color: _diffColor(problem.difficulty),
                  fontWeight: FontWeight.w700,
                )),
          ],
        ),
      ),
    );
  }

  Color _diffColor(String d) {
    switch (d.toLowerCase()) {
      case 'easy':
        return const Color(0xFF43A047);
      case 'medium':
        return const Color(0xFFFFA726);
      case 'hard':
        return const Color(0xFFE53935);
      default:
        return UiConstants.subtitleTextColor;
    }
  }
}
