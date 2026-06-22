import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lab_portal/core/di/injection.dart';
import 'package:lab_portal/core/theme/app_spacing.dart';
import 'package:lab_portal/core/theme/app_text_styles.dart';
import 'package:lab_portal/core/ui_constants.dart';
import 'package:lab_portal/core/widgets/async_view.dart';
import 'package:lab_portal/core/widgets/ui_kit.dart';
import 'package:lab_portal/future/main/presentation/page/base_page.dart';
import '../../domain/entity/topic_entity.dart';
import '../../domain/service/learning_path_engine.dart';
import '../bloc/topics/topics_bloc.dart';
import '../widget/topic_node.dart';
import '../widget/up_next_strip.dart';
import 'topic_detail_page.dart';

class SkillTreePage extends StatelessWidget {
  const SkillTreePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<TopicsBloc>()..add(const TopicsStarted()),
      child: BasePage(
        title: 'Learn',
        subtitle: 'Your CP curriculum',
        selectedIndex: 2,
        body: BlocBuilder<TopicsBloc, TopicsState>(
          builder: (context, state) => AsyncView<TopicsLoaded>(
            isLoading: state is TopicsLoading || state is TopicsInitial,
            error: state is TopicsError ? state.message : null,
            data: state is TopicsLoaded ? state : null,
            onRetry: () =>
                context.read<TopicsBloc>().add(const TopicsStarted()),
            emptyMessage: 'No topics found',
            builder: (loaded) => _Body(loaded: loaded),
          ),
        ),
      ),
    );
  }
}

class _Body extends StatelessWidget {
  final TopicsLoaded loaded;

  const _Body({required this.loaded});

  @override
  Widget build(BuildContext context) {
    final topics = loaded.topics;
    final progress = loaded.progress;
    final frontier = loaded.frontier;

    // Group by category for swimlane layout.
    final categories = <String, List<TopicEntity>>{};
    for (final t in topics) {
      categories.putIfAbsent(t.category, () => []).add(t);
    }

    return CustomScrollView(
      slivers: [
        // Courses banner — taps to CoursesPage.
        SliverToBoxAdapter(
          child: Padding(
            padding: AppSpacing.pageH.add(const EdgeInsets.only(top: 12)),
            child: GestureDetector(
              onTap: () => Navigator.pushNamed(context, '/courses'),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      UiConstants.primaryButtonColor,
                      UiConstants.primaryDark,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.play_lesson_outlined,
                        color: Colors.white, size: 32),
                    const SizedBox(width: 14),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Courses',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w900)),
                          Text('Video · Article · PDF lessons',
                              style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 12)),
                        ],
                      ),
                    ),
                    const Icon(Icons.chevron_right_rounded,
                        color: Colors.white70),
                  ],
                ),
              ),
            ),
          ),
        ),
        // Overall progress bar + Up-next strip.
        SliverToBoxAdapter(
          child: Padding(
            padding: AppSpacing.pageH,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: AppSpacing.sm),
                _OverallHeader(ratio: loaded.overallRatio, topics: topics, progress: progress),
                const SizedBox(height: AppSpacing.md),
                UpNextStrip(
                  frontier: frontier,
                  onTap: (t) => _openDetail(context, t, progress),
                ),
                const SizedBox(height: AppSpacing.md),
              ],
            ),
          ),
        ),

        // Category swimlanes.
        for (final entry in categories.entries) ...[
          SliverToBoxAdapter(
            child: Padding(
              padding: AppSpacing.pageH,
              child: SectionHeader(entry.key),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, i) {
                final t = entry.value[i];
                final p = progress[t.id]!;
                return Padding(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.md,
                    0,
                    AppSpacing.md,
                    AppSpacing.xs,
                  ),
                  child: TopicNode(
                    topic: t,
                    progress: p,
                    onTap: () => _openDetail(context, t, progress),
                  ),
                );
              },
              childCount: entry.value.length,
            ),
          ),
        ],
        const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.xl)),
      ],
    );
  }

  void _openDetail(
    BuildContext context,
    TopicEntity topic,
    Map<String, TopicProgress> progress,
  ) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => TopicDetailPage(
          topic: topic,
          progress: progress[topic.id]!,
          allProgress: progress,
        ),
      ),
    );
  }
}

class _OverallHeader extends StatelessWidget {
  final double ratio;
  final List<TopicEntity> topics;
  final Map<String, TopicProgress> progress;

  const _OverallHeader({
    required this.ratio,
    required this.topics,
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    final done = progress.values
        .where((p) => p.status == TopicStatus.completed)
        .length;
    final available = progress.values
        .where((p) => p.status == TopicStatus.available)
        .length;

    return GradientCard(
      child: Row(
        children: [
          ProgressRing(
            ratio: ratio,
            size: 64,
            stroke: 7,
            center: Text(
              '${(ratio * 100).round()}%',
              style: AppTextStyles.stat.copyWith(
                color: UiConstants.primaryButtonColor,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Curriculum progress', style: AppTextStyles.title),
                const SizedBox(height: AppSpacing.xs),
                Wrap(
                  spacing: AppSpacing.xs,
                  runSpacing: AppSpacing.xs,
                  children: [
                    StatPill(
                      'Done',
                      '$done',
                      color: UiConstants.primaryButtonColor,
                      icon: Icons.check_circle_outline_rounded,
                    ),
                    StatPill(
                      'Available',
                      '$available',
                      color: UiConstants.ratingTextColor,
                      icon: Icons.bolt_rounded,
                    ),
                    StatPill(
                      'Total',
                      '${topics.length}',
                      color: UiConstants.subtitleTextColor,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
