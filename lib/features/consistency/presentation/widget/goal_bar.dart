import 'package:flutter/material.dart';
import 'package:lab_portal/core/theme/app_radii.dart';
import 'package:lab_portal/core/theme/app_spacing.dart';
import 'package:lab_portal/core/theme/app_text_styles.dart';
import 'package:lab_portal/core/ui_constants.dart';
import 'package:lab_portal/core/widgets/ui_kit.dart';

class GoalBar extends StatelessWidget {
  final String label;
  final int progress;
  final int target;
  final VoidCallback? onEditTap;

  const GoalBar({
    super.key,
    required this.label,
    required this.progress,
    required this.target,
    this.onEditTap,
  });

  @override
  Widget build(BuildContext context) {
    final ratio = target == 0 ? 0.0 : (progress / target).clamp(0.0, 1.0);
    final done = progress >= target;
    final color =
        done ? UiConstants.primaryButtonColor : UiConstants.statTextColor;

    return GradientCard(
      accent: color,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(child: Text(label, style: AppTextStyles.title)),
              if (onEditTap != null)
                GestureDetector(
                  onTap: onEditTap,
                  child: const Icon(Icons.edit_outlined,
                      size: 16, color: UiConstants.subtitleTextColor),
                ),
              const SizedBox(width: AppSpacing.xs),
              Text(
                '$progress / $target',
                style: AppTextStyles.stat.copyWith(color: color),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          ClipRRect(
            borderRadius: BorderRadius.circular(AppRadii.pill),
            child: LinearProgressIndicator(
              value: ratio,
              minHeight: 8,
              backgroundColor: color.withOpacity(0.12),
              valueColor: AlwaysStoppedAnimation<Color>(color),
            ),
          ),
          if (done) ...[
            const SizedBox(height: AppSpacing.xs),
            Row(
              children: [
                const Icon(Icons.celebration_rounded,
                    size: 14, color: UiConstants.primaryButtonColor),
                const SizedBox(width: 4),
                Text('Goal met — keep going!', style: AppTextStyles.caption),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
