// lib/features/consistency/presentation/widget/consistency_widgets.dart
//
// Phase 10 — signature UI for the consistency hub. StreakRing, GoalBar and
// LadderRungTile, all built on ui_kit. These are the daily-return surfaces:
// keep them dense, glanceable, and above the fold on Home.

import 'package:flutter/material.dart';
import 'package:lab_portal/core/theme/app_radii.dart';
import 'package:lab_portal/core/theme/app_spacing.dart';
import 'package:lab_portal/core/theme/app_text_styles.dart';
import 'package:lab_portal/core/ui_constants.dart';
import 'package:lab_portal/core/widgets/ui_kit.dart';

/// Big streak number in a flame ring. The emotional anchor of the app.
class StreakRing extends StatelessWidget {
  final int current;
  final int longest;
  final int freezesAvailable;
  // 0..1 progress through *this week* (active days / 7) drives the ring fill.
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
    const flame = UiConstants.ratingTextColor; // gold — "hot streak"
    return GradientCard(
      accent: flame,
      child: Row(
        children: [
          ProgressRing(
            ratio: weekRatio,
            size: 76,
            stroke: 7,
            color: flame,
            center: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('$current', style: AppTextStyles.h1.copyWith(color: flame, height: 1)),
                const Text('days', style: AppTextStyles.caption),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(children: [
                  const Icon(Icons.local_fire_department_rounded, color: flame, size: 20),
                  const SizedBox(width: 6),
                  Text('Current streak', style: AppTextStyles.title),
                ]),
                const SizedBox(height: AppSpacing.xs),
                Wrap(
                  spacing: AppSpacing.xs,
                  runSpacing: AppSpacing.xs,
                  children: [
                    StatPill('Longest', '$longest', color: UiConstants.primaryButtonColor),
                    StatPill('Freezes', '$freezesAvailable',
                        color: UiConstants.problemTextColor, icon: Icons.ac_unit_rounded),
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

/// Weekly goal progress bar. label + n/target + a thin track.
class GoalBar extends StatelessWidget {
  final String label; // 'Problems this week'
  final int progress;
  final int target;

  const GoalBar({super.key, required this.label, required this.progress, required this.target});

  @override
  Widget build(BuildContext context) {
    final ratio = target == 0 ? 0.0 : (progress / target).clamp(0.0, 1.0);
    final done = progress >= target;
    final color = done ? UiConstants.primaryButtonColor : UiConstants.statTextColor;
    return GradientCard(
      accent: color,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Expanded(child: Text(label, style: AppTextStyles.title)),
            Text('$progress / $target', style: AppTextStyles.stat.copyWith(color: color)),
          ]),
          const SizedBox(height: AppSpacing.sm),
          ClipRRect(
            borderRadius: BorderRadius.circular(AppRadii.pill),
            child: LinearProgressIndicator(
              value: ratio,
              minHeight: 8,
              backgroundColor: color.withOpacity(0.12),
              valueColor: AlwaysStoppedAnimation(color),
            ),
          ),
          if (done) ...[
            const SizedBox(height: AppSpacing.xs),
            Row(children: [
              const Icon(Icons.celebration_rounded, size: 14, color: UiConstants.primaryButtonColor),
              const SizedBox(width: 4),
              Text('Goal met — nice.', style: AppTextStyles.caption),
            ]),
          ],
        ],
      ),
    );
  }
}

/// One rung in a ladder. Solved rungs fill; the first unsolved rung is the
/// highlighted "today's rung".
class LadderRungTile extends StatelessWidget {
  final int rating;
  final String problemTitle;
  final bool solved;
  final bool isToday; // first unsolved rung
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
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: accent.withOpacity(0.12),
              borderRadius: AppRadii.rSm,
              border: Border.all(color: accent.withOpacity(0.22)),
            ),
            child: Center(
              child: solved
                  ? const Icon(Icons.check_rounded, color: UiConstants.primaryButtonColor)
                  : Text('$rating',
                      style: AppTextStyles.caption.copyWith(color: accent, fontWeight: FontWeight.w900)),
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(problemTitle, style: AppTextStyles.body, maxLines: 1, overflow: TextOverflow.ellipsis),
                if (topicLabel != null)
                  Text(topicLabel!, style: AppTextStyles.caption),
              ],
            ),
          ),
          if (isToday && !solved)
            StatusChip(
                label: 'Today', icon: Icons.bolt_rounded, color: UiConstants.ratingTextColor),
        ],
      ),
    );
  }
}
