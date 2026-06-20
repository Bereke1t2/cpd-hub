import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lab_portal/core/di/injection.dart';
import 'package:lab_portal/core/theme/app_spacing.dart';
import 'package:lab_portal/core/theme/app_text_styles.dart';
import 'package:lab_portal/core/ui_constants.dart';
import 'package:lab_portal/core/widgets/ui_kit.dart';
import '../../domain/entity/track_entity.dart';
import '../../domain/service/learning_path_engine.dart';
import '../bloc/topics/topics_bloc.dart';
import '../widget/topic_node.dart';
import 'topic_detail_page.dart';

class TrackDetailPage extends StatelessWidget {
  final TrackEntity track;
  final double completion;

  const TrackDetailPage({
    super.key,
    required this.track,
    required this.completion,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<TopicsBloc>()..add(const TopicsStarted()),
      child: Scaffold(
        backgroundColor: UiConstants.backgroundColor,
        appBar: AppBar(
          backgroundColor: UiConstants.infoBackgroundColor,
          foregroundColor: UiConstants.mainTextColor,
          elevation: 0,
          title: Text(track.title, style: AppTextStyles.title),
        ),
        body: BlocBuilder<TopicsBloc, TopicsState>(
          builder: (context, state) {
            final progress = state is TopicsLoaded ? state.progress : <String, TopicProgress>{};
            final topics = state is TopicsLoaded ? state.topics : [];
            final topicMap = {for (final t in topics) t.id: t};

            // Find the first non-completed topic — the "current step".
            final currentIdx = track.topicIds.indexWhere(
              (id) => progress[id]?.status != TopicStatus.completed,
            );

            return CustomScrollView(
              slivers: [
                // Header — track summary + overall progress.
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    child: GradientCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(track.title,
                                        style: AppTextStyles.title),
                                    const SizedBox(height: 4),
                                    Text(track.description,
                                        style: AppTextStyles.caption),
                                  ],
                                ),
                              ),
                              const SizedBox(width: AppSpacing.sm),
                              ProgressRing(
                                ratio: completion,
                                size: 56,
                                stroke: 6,
                                center: Text(
                                  '${(completion * 100).round()}%',
                                  style: AppTextStyles.caption.copyWith(
                                    color: UiConstants.primaryButtonColor,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: AppSpacing.sm),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(999),
                            child: LinearProgressIndicator(
                              value: completion.clamp(0.0, 1.0),
                              minHeight: 6,
                              backgroundColor: UiConstants.primaryButtonColor
                                  .withOpacity(0.12),
                              valueColor: const AlwaysStoppedAnimation<Color>(
                                UiConstants.primaryButtonColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // Vertical stepper — one row per topic in order.
                SliverPadding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.md),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, i) {
                        final topicId = track.topicIds[i];
                        final topic = topicMap[topicId];
                        final prog = progress[topicId];
                        final isCurrentStep = i == currentIdx;
                        final isLast = i == track.topicIds.length - 1;

                        return IntrinsicHeight(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              // Step indicator column.
                              SizedBox(
                                width: 40,
                                child: Column(
                                  children: [
                                    _StepDot(
                                      index: i,
                                      status: prog?.status ??
                                          TopicStatus.locked,
                                      isCurrent: isCurrentStep,
                                    ),
                                    if (!isLast)
                                      Expanded(
                                        child: Container(
                                          width: 2,
                                          color: UiConstants.borderColor,
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: AppSpacing.sm),

                              // Topic card.
                              Expanded(
                                child: Padding(
                                  padding: EdgeInsets.only(
                                      bottom: isLast ? AppSpacing.xl : AppSpacing.xs),
                                  child: topic == null
                                      ? GradientCard(
                                          dimmed: true,
                                          child: Text(
                                            topicId,
                                            style: AppTextStyles.caption,
                                          ),
                                        )
                                      : TopicNode(
                                          topic: topic,
                                          progress: prog ??
                                              const TopicProgress(
                                                status: TopicStatus.locked,
                                                solved: 0,
                                                total: 0,
                                              ),
                                          onTap: () => Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (_) => TopicDetailPage(
                                                topic: topic,
                                                progress: prog ??
                                                    const TopicProgress(
                                                      status:
                                                          TopicStatus.locked,
                                                      solved: 0,
                                                      total: 0,
                                                    ),
                                                allProgress: progress,
                                              ),
                                            ),
                                          ),
                                        ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                      childCount: track.topicIds.length,
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _StepDot extends StatelessWidget {
  final int index;
  final TopicStatus status;
  final bool isCurrent;

  const _StepDot({
    required this.index,
    required this.status,
    required this.isCurrent,
  });

  @override
  Widget build(BuildContext context) {
    final style = TopicStatusStyle.of(status);
    final bg = isCurrent
        ? UiConstants.ratingTextColor
        : style.color.withOpacity(0.15);
    final fg = isCurrent ? Colors.black : style.color;

    return Container(
      width: 28,
      height: 28,
      decoration: BoxDecoration(
        color: bg,
        shape: BoxShape.circle,
        border: Border.all(color: style.color, width: 1.5),
      ),
      child: Center(
        child: status == TopicStatus.completed
            ? Icon(Icons.check_rounded, size: 14, color: fg)
            : Text(
                '${index + 1}',
                style: TextStyle(
                  color: fg,
                  fontSize: 11,
                  fontWeight: FontWeight.w900,
                ),
              ),
      ),
    );
  }
}
