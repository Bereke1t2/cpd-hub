// lib/features/learning/presentation/widget/skill_tree_widgets.dart
//
// Phase 9 — signature UI for the skill tree. TopicNode renders the three states
// (completed / available / locked) consistently; UpNextStrip is the horizontal
// "do this next" rail at the top of the page. Both are built from ui_kit so
// they inherit the app's card/colour rhythm.

import 'package:flutter/material.dart';
import 'package:lab_portal/core/theme/app_radii.dart';
import 'package:lab_portal/core/theme/app_spacing.dart';
import 'package:lab_portal/core/theme/app_text_styles.dart';
import 'package:lab_portal/core/ui_constants.dart';
import 'package:lab_portal/core/widgets/ui_kit.dart';
import '../../domain/entity/topic_entity.dart';
import '../../domain/service/learning_path_engine.dart';

/// Single source of truth for how each status looks. Reuse everywhere a topic
/// state is shown (tree node, detail header, track stepper) so the language is
/// identical across screens.
class TopicStatusStyle {
  final Color color;
  final IconData icon;
  final String label;
  const TopicStatusStyle(this.color, this.icon, this.label);

  static TopicStatusStyle of(TopicStatus s) {
    switch (s) {
      case TopicStatus.completed:
        return const TopicStatusStyle(
            UiConstants.primaryButtonColor, Icons.check_circle_rounded, 'Completed');
      case TopicStatus.available:
        return const TopicStatusStyle(
            UiConstants.ratingTextColor, Icons.play_circle_fill_rounded, 'Start now');
      case TopicStatus.locked:
        return const TopicStatusStyle(
            UiConstants.subtitleTextColor, Icons.lock_rounded, 'Locked');
    }
  }
}

class TopicNode extends StatelessWidget {
  final TopicEntity topic;
  final TopicProgress progress;
  final VoidCallback onTap;

  const TopicNode({
    super.key,
    required this.topic,
    required this.progress,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final style = TopicStatusStyle.of(progress.status);
    final locked = progress.status == TopicStatus.locked;

    return GradientCard(
      accent: style.color,
      dimmed: locked,
      onTap: onTap,
      child: Row(
        children: [
          // Status / progress indicator.
          ProgressRing(
            ratio: progress.ratio,
            size: 46,
            stroke: 5,
            color: style.color,
            center: Icon(style.icon, size: 18, color: style.color),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(topic.name, style: AppTextStyles.title, maxLines: 1, overflow: TextOverflow.ellipsis),
                const SizedBox(height: 2),
                Text('${progress.solved}/${progress.total} problems · ${topic.category}',
                    style: AppTextStyles.caption),
                if (locked && progress.unmetPrerequisiteIds.isNotEmpty) ...[
                  const SizedBox(height: AppSpacing.xs),
                  Text('Needs: ${progress.unmetPrerequisiteIds.join(', ')}',
                      style: AppTextStyles.caption
                          .copyWith(color: UiConstants.subtitleTextColor, fontStyle: FontStyle.italic),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis),
                ],
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.xs),
          StatusChip(label: style.label, icon: style.icon, color: style.color),
        ],
      ),
    );
  }
}

/// Horizontal "Up next" rail — the highest-value surface. Feed it
/// LearningPathEngine.frontier(...).
class UpNextStrip extends StatelessWidget {
  final List<TopicEntity> frontier;
  final void Function(TopicEntity) onTap;

  const UpNextStrip({super.key, required this.frontier, required this.onTap});

  @override
  Widget build(BuildContext context) {
    if (frontier.isEmpty) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader('Up next', icon: Icons.bolt_rounded, accent: UiConstants.ratingTextColor),
        SizedBox(
          height: 92,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxs),
            itemCount: frontier.length,
            separatorBuilder: (_, __) => const SizedBox(width: AppSpacing.xs),
            itemBuilder: (context, i) {
              final t = frontier[i];
              return SizedBox(
                width: 200,
                child: GradientCard(
                  accent: UiConstants.ratingTextColor,
                  radius: AppRadii.md,
                  onTap: () => onTap(t),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(t.category.toUpperCase(),
                          style: AppTextStyles.caption.copyWith(letterSpacing: 0.5)),
                      const SizedBox(height: 4),
                      Text(t.name,
                          style: AppTextStyles.title, maxLines: 1, overflow: TextOverflow.ellipsis),
                      const SizedBox(height: 6),
                      Row(children: [
                        const Icon(Icons.play_arrow_rounded,
                            size: 16, color: UiConstants.ratingTextColor),
                        Text(' Start · difficulty ${t.difficulty}', style: AppTextStyles.caption),
                      ]),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
