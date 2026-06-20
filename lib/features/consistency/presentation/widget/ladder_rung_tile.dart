import 'package:flutter/material.dart';
import 'package:lab_portal/core/theme/app_radii.dart';
import 'package:lab_portal/core/theme/app_spacing.dart';
import 'package:lab_portal/core/theme/app_text_styles.dart';
import 'package:lab_portal/core/ui_constants.dart';
import 'package:lab_portal/core/widgets/ui_kit.dart';

class LadderRungTile extends StatelessWidget {
  final int rating;
  final String problemTitle;
  final bool solved;

  /// True for the first unsolved rung — the "today's rung".
  final bool isToday;
  final String? topicLabel;
  final VoidCallback onTap;

  const LadderRungTile({
    super.key,
    required this.rating,
    required this.problemTitle,
    required this.solved,
    required this.isToday,
    required this.onTap,
    this.topicLabel,
  });

  @override
  Widget build(BuildContext context) {
    final accent = solved
        ? UiConstants.primaryButtonColor
        : (isToday ? UiConstants.ratingTextColor : UiConstants.subtitleTextColor);

    return GradientCard(
      accent: accent,
      dimmed: !solved && !isToday,
      onTap: onTap,
      radius: AppRadii.md,
      child: Row(
        children: [
          // Rating badge
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: accent.withOpacity(0.12),
              borderRadius: AppRadii.rSm,
              border: Border.all(color: accent.withOpacity(0.22)),
            ),
            child: Center(
              child: solved
                  ? Icon(Icons.check_rounded, color: accent, size: 20)
                  : Text(
                      '$rating',
                      style: AppTextStyles.caption.copyWith(
                        color: accent,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  problemTitle,
                  style: AppTextStyles.body,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                if (topicLabel != null)
                  Text(topicLabel!, style: AppTextStyles.caption),
              ],
            ),
          ),
          if (isToday && !solved)
            StatusChip(
              label: 'Today',
              icon: Icons.bolt_rounded,
              color: UiConstants.ratingTextColor,
            ),
        ],
      ),
    );
  }
}
