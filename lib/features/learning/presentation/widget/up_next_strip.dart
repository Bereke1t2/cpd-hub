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

  const UpNextStrip({super.key, required this.frontier, required this.onTap});

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
        // Intrinsic height (no hardcoded box) so the rail grows with the
        // device text scale instead of clipping its content.
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxs),
          // IntrinsicHeight gives the row a bounded height (the tallest card)
          // so `stretch` works even though the rail itself has no fixed height.
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                for (var i = 0; i < frontier.length; i++) ...[
                  if (i > 0) const SizedBox(width: AppSpacing.xs),
                  SizedBox(
                    width: 200,
                    child: GradientCard(
                      accent: UiConstants.ratingTextColor,
                      radius: AppRadii.md,
                      padding: const EdgeInsets.all(AppSpacing.sm),
                      onTap: () => onTap(frontier[i]),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            frontier[i].category.toUpperCase(),
                            style: AppTextStyles.caption.copyWith(
                              letterSpacing: 0.6,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            frontier[i].name,
                            style: AppTextStyles.title,
                            maxLines: 2,
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
                              // Flexible + ellipsis so the label can't push the
                              // row past the 200-px card width.
                              Flexible(
                                child: Text(
                                  ' Start · level ${frontier[i].difficulty}',
                                  style: AppTextStyles.caption,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }
}
