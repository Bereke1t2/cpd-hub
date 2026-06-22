import 'package:flutter/material.dart';
import 'package:lab_portal/core/theme/app_spacing.dart';
import 'package:lab_portal/core/theme/app_text_styles.dart';
import 'package:lab_portal/core/ui_constants.dart';
import 'package:lab_portal/core/widgets/ui_kit.dart';
import '../../domain/entity/topic_entity.dart';
import '../../domain/service/learning_path_engine.dart';

/// Single source of truth for how each [TopicStatus] looks.
/// Reused on the skill tree, topic detail header, and track stepper.
class TopicStatusStyle {
  final Color color;
  final IconData icon;
  final String label;

  const TopicStatusStyle(this.color, this.icon, this.label);

  static TopicStatusStyle of(TopicStatus s) {
    switch (s) {
      case TopicStatus.completed:
        return const TopicStatusStyle(
          UiConstants.primaryButtonColor,
          Icons.check_circle_rounded,
          'Completed',
        );
      case TopicStatus.available:
        return const TopicStatusStyle(
          UiConstants.ratingTextColor,
          Icons.play_circle_fill_rounded,
          'Start now',
        );
      case TopicStatus.locked:
        return const TopicStatusStyle(
          UiConstants.subtitleTextColor,
          Icons.lock_rounded,
          'Locked',
        );
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
                Text(
                  topic.name,
                  style: AppTextStyles.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  '${progress.solved}/${progress.total} problems · ${topic.category}',
                  style: AppTextStyles.caption,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                if (locked && progress.unmetPrerequisiteIds.isNotEmpty) ...[
                  const SizedBox(height: AppSpacing.xxs),
                  Text(
                    'Needs: ${progress.unmetPrerequisiteIds.join(', ')}',
                    style: AppTextStyles.caption.copyWith(
                      fontStyle: FontStyle.italic,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
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
