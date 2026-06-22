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
      // Blended, title-less bar so the hero below carries the topic identity
      // (no more duplicated name in the bar + the card).
      appBar: AppBar(
        backgroundColor: UiConstants.backgroundColor,
        foregroundColor: UiConstants.mainTextColor,
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      body: CustomScrollView(
        slivers: [
          // ── Hero: category · name · status · difficulty · summary · progress
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                  AppDimens.lg, AppDimens.lg, AppDimens.lg, 0),
              child: GradientCard(
                accent: style.color,
                padding: const EdgeInsets.all(AppDimens.lg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Overline — category, in muted small caps.
                    Text(
                      topic.category.toUpperCase(),
                      style: AppTextStyles.caption.copyWith(
                        letterSpacing: 1.2,
                        fontWeight: FontWeight.w700,
                        color: style.color,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: AppDimens.xs),
                    Text(
                      topic.name,
                      style: AppTextStyles.hero,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: AppDimens.md),
                    // Status + difficulty — Wrap so they never overflow.
                    Wrap(
                      spacing: AppDimens.sm,
                      runSpacing: AppDimens.xs,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        StatusChip(
                          label: style.label,
                          icon: style.icon,
                          color: style.color,
                        ),
                        _DifficultyChip(level: topic.difficulty),
                      ],
                    ),
                    if (topic.summary.trim().isNotEmpty) ...[
                      const SizedBox(height: AppDimens.md),
                      Text(
                        topic.summary,
                        style: AppTextStyles.body.copyWith(
                          color: UiConstants.subtitleTextColor,
                          height: 1.55,
                        ),
                      ),
                    ],
                    const SizedBox(height: AppDimens.lg),
                    // Progress — a linear bar reads as "how far am I" instantly.
                    Row(
                      children: [
                        Text('PROGRESS',
                            style: AppTextStyles.micro.copyWith(
                              fontWeight: FontWeight.w800,
                              letterSpacing: 0.8,
                            )),
                        const Spacer(),
                        Text(
                          '${progress.solved} / ${progress.total} solved',
                          style: AppTextStyles.caption.copyWith(
                            color: UiConstants.primaryButtonColor,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppDimens.sm),
                    ClipRRect(
                      borderRadius: AppDimens.brSm,
                      child: LinearProgressIndicator(
                        value: progress.ratio.clamp(0.0, 1.0),
                        minHeight: 8,
                        backgroundColor: UiConstants.primaryButtonColor
                            .withValues(alpha: 0.12),
                        valueColor: const AlwaysStoppedAnimation<Color>(
                            UiConstants.primaryButtonColor),
                      ),
                    ),
                  ],
                ),
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

/// Difficulty as 1–5 filled dots — calmer and more "grown-up" than a
/// "Level 3 / 5" text pill, and self-contained so it can't overflow.
class _DifficultyChip extends StatelessWidget {
  final int level;
  const _DifficultyChip({required this.level});

  @override
  Widget build(BuildContext context) {
    const c = UiConstants.primaryButtonColor;
    final clamped = level.clamp(0, 5);
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimens.sm,
        vertical: AppDimens.xs,
      ),
      decoration: BoxDecoration(
        color: c.withValues(alpha: 0.12),
        borderRadius: AppDimens.brSm,
        border: Border.all(color: c.withValues(alpha: 0.22)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.bolt_rounded, size: 13, color: c),
          const SizedBox(width: 6),
          for (var i = 0; i < 5; i++)
            Padding(
              padding: EdgeInsets.only(right: i == 4 ? 0 : 3),
              child: Container(
                width: 6,
                height: 6,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: i < clamped ? c : c.withValues(alpha: 0.25),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

// ── Concept (lesson body + key ideas) ─────────────────────────────────────────
class _ConceptCard extends StatelessWidget {
  final LessonEntity lesson;
  const _ConceptCard({required this.lesson});

  @override
  Widget build(BuildContext context) {
    // Split the body into paragraphs for a calmer reading rhythm.
    final paragraphs = lesson.body
        .split('\n')
        .map((p) => p.trim())
        .where((p) => p.isNotEmpty)
        .toList();

    return GradientCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeader('Concept',
              icon: Icons.lightbulb_outline_rounded),
          const SizedBox(height: AppDimens.xs),
          for (var i = 0; i < paragraphs.length; i++)
            Padding(
              padding: EdgeInsets.only(
                  bottom: i == paragraphs.length - 1 ? 0 : AppDimens.sm),
              child: _ArticleText(paragraphs[i]),
            ),

          // Code sample.
          if (lesson.code != null && lesson.code!.trim().isNotEmpty) ...[
            const SizedBox(height: AppDimens.md),
            _CodeBlock(code: lesson.code!, language: lesson.codeLang),
          ],

          // Key ideas.
          if (lesson.keyIdeas.isNotEmpty) ...[
            const SizedBox(height: AppDimens.md),
            Text('KEY IDEAS',
                style: AppTextStyles.caption.copyWith(
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.8,
                )),
            const SizedBox(height: AppDimens.sm),
            for (final idea in lesson.keyIdeas)
              Padding(
                padding: const EdgeInsets.only(bottom: AppDimens.sm),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 3),
                      child: Icon(Icons.check_circle_rounded,
                          size: 15,
                          color: UiConstants.primaryButtonColor
                              .withValues(alpha: 0.9)),
                    ),
                    const SizedBox(width: AppDimens.sm),
                    Expanded(child: _ArticleText(idea)),
                  ],
                ),
              ),
          ],
        ],
      ),
    );
  }
}

/// Body text that renders `inline code` (backtick-wrapped) in a monospace
/// pill and *emphasis* (asterisk-wrapped) in italic — comfortable line height.
class _ArticleText extends StatelessWidget {
  final String text;
  const _ArticleText(this.text);

  @override
  Widget build(BuildContext context) {
    const base = TextStyle(
      color: UiConstants.mainTextColor,
      fontSize: AppDimens.fBody,
      height: 1.6,
    );
    final spans = <InlineSpan>[];
    // Tokenize on `code` and *emphasis*.
    final re = RegExp(r'`([^`]+)`|\*([^*]+)\*');
    var last = 0;
    for (final m in re.allMatches(text)) {
      if (m.start > last) {
        spans.add(TextSpan(text: text.substring(last, m.start)));
      }
      if (m.group(1) != null) {
        spans.add(TextSpan(
          text: ' ${m.group(1)} ',
          style: const TextStyle(
            fontFamily: 'monospace',
            fontSize: AppDimens.fBody - 0.5,
            color: UiConstants.primaryButtonColor,
            backgroundColor: UiConstants.backgroundColor,
            height: 1.5,
          ),
        ));
      } else {
        spans.add(TextSpan(
          text: m.group(2),
          style: const TextStyle(fontStyle: FontStyle.italic),
        ));
      }
      last = m.end;
    }
    if (last < text.length) {
      spans.add(TextSpan(text: text.substring(last)));
    }
    return Text.rich(TextSpan(style: base, children: spans));
  }
}

/// A horizontally-scrollable monospace code block with a small header.
class _CodeBlock extends StatelessWidget {
  final String code;
  final String? language;
  const _CodeBlock({required this.code, this.language});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: UiConstants.backgroundColor,
        borderRadius: AppDimens.brSm,
        border: Border.all(
            color: UiConstants.primaryButtonColor.withValues(alpha: 0.18)),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header: language label + faux window dots.
          Container(
            padding: const EdgeInsets.symmetric(
                horizontal: AppDimens.md, vertical: AppDimens.xs),
            color: UiConstants.primaryButtonColor.withValues(alpha: 0.08),
            child: Row(
              children: [
                Icon(Icons.code_rounded,
                    size: 14,
                    color: UiConstants.primaryButtonColor
                        .withValues(alpha: 0.9)),
                const SizedBox(width: AppDimens.xs),
                Text(
                  (language ?? 'code').toUpperCase(),
                  style: AppTextStyles.micro.copyWith(
                    color: UiConstants.primaryButtonColor,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.6,
                  ),
                ),
              ],
            ),
          ),
          // Code (scrolls sideways for long lines).
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.all(AppDimens.md),
            child: Text(
              code,
              style: const TextStyle(
                fontFamily: 'monospace',
                fontSize: AppDimens.fBody,
                height: 1.5,
                color: UiConstants.mainTextColor,
              ),
            ),
          ),
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
