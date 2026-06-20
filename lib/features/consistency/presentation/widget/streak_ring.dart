import 'package:flutter/material.dart';
import 'package:lab_portal/core/theme/app_spacing.dart';
import 'package:lab_portal/core/theme/app_text_styles.dart';
import 'package:lab_portal/core/ui_constants.dart';
import 'package:lab_portal/core/widgets/ui_kit.dart';

class StreakRing extends StatelessWidget {
  final int current;
  final int longest;
  final int freezesAvailable;

  /// 0..1 — fraction of the last 7 days that were active.
  final double weekRatio;

  const StreakRing({
    super.key,
    required this.current,
    required this.longest,
    required this.freezesAvailable,
    required this.weekRatio,
  });

  @override
  Widget build(BuildContext context) {
    const flame = UiConstants.ratingTextColor;
    return GradientCard(
      accent: flame,
      child: Row(
        children: [
          ProgressRing(
            ratio: weekRatio,
            size: 72,
            stroke: 7,
            color: flame,
            center: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.local_fire_department_rounded,
                    color: flame, size: 16),
                Text(
                  '$current',
                  style: AppTextStyles.h1.copyWith(
                    color: flame,
                    height: 1,
                    fontSize: 22,
                  ),
                ),
                Text('days', style: AppTextStyles.caption),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Current streak', style: AppTextStyles.title),
                const SizedBox(height: AppSpacing.xs),
                Wrap(
                  spacing: AppSpacing.xs,
                  runSpacing: AppSpacing.xs,
                  children: [
                    StatPill(
                      'Longest',
                      '$longest',
                      color: UiConstants.primaryButtonColor,
                      icon: Icons.emoji_events_rounded,
                    ),
                    StatPill(
                      'Freezes',
                      '$freezesAvailable',
                      color: UiConstants.problemTextColor,
                      icon: Icons.ac_unit_rounded,
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
