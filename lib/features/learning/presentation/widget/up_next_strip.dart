import 'package:flutter/material.dart';
import 'package:lab_portal/core/theme/app_radii.dart';
import 'package:lab_portal/core/theme/app_spacing.dart';
import 'package:lab_portal/core/theme/app_text_styles.dart';
import 'package:lab_portal/core/ui_constants.dart';
import 'package:lab_portal/core/widgets/ui_kit.dart';
import '../../domain/entity/topic_entity.dart';

/// Horizontal "Up next" rail — the highest-value surface on the skill tree.
/// Feed it [LearningPathEngine.frontier(...)].
class UpNextStrip extends StatelessWidget {
  final List<TopicEntity> frontier;
  final void Function(TopicEntity) onTap;

  const UpNextStrip({
    super.key,
    required this.frontier,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    if (frontier.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader(
          'Up next',
          icon: Icons.bolt_rounded,
          accent: UiConstants.ratingTextColor,
        ),
        SizedBox(
          height: 96,
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
                  padding: const EdgeInsets.all(AppSpacing.sm),
                  onTap: () => onTap(t),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        t.category.toUpperCase(),
                        style: AppTextStyles.caption
                            .copyWith(letterSpacing: 0.6),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        t.name,
                        style: AppTextStyles.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          const Icon(
                            Icons.play_arrow_rounded,
                            size: 15,
                            color: UiConstants.ratingTextColor,
                          ),
                          Text(
                            ' Start · level ${t.difficulty}',
                            style: AppTextStyles.caption,
                          ),
                        ],
                      ),
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
