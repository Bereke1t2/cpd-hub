// lib/core/widgets/ui_kit.dart
//
// Shared "modern look" building blocks. EVERY phase-9/10/11 screen is assembled
// from these — that is what keeps the app visually consistent. Do not hand-roll
// a Container+BoxDecoration in a feature widget; compose these instead.
//
// Design recipe (the "CPD card"): dark surface + a faint accent-tinted gradient
// + large radius + soft shadow + hairline border. Accent comes from meaning
// (rating tier, topic status, difficulty), never decoration.
//
// Tokens come from Phase 0/1: AppSpacing, AppRadii, AppTextStyles, UiConstants.
// NB: this repo uses `withOpacity` everywhere; new code matches it for analyze
// consistency (equivalent to the newer `withValues(alpha:)`).

import 'package:flutter/material.dart';
import 'package:lab_portal/core/theme/app_radii.dart';
import 'package:lab_portal/core/theme/app_spacing.dart';
import 'package:lab_portal/core/theme/app_text_styles.dart';
import 'package:lab_portal/core/ui_constants.dart';

/// The canonical surface. One card style for the whole app.
///
/// ```dart
/// GradientCard(
///   accent: UiConstants.getUserRatingColor(user.rating),
///   child: ...,
/// )
/// ```
class GradientCard extends StatelessWidget {
  final Widget child;
  final Color? accent; // defaults to primary green
  final EdgeInsetsGeometry padding;
  final double radius;
  final VoidCallback? onTap;
  final bool dimmed; // for "locked" / inactive states

  const GradientCard({
    super.key,
    required this.child,
    this.accent,
    this.padding = AppSpacing.card,
    this.radius = AppRadii.lg,
    this.onTap,
    this.dimmed = false,
  });

  @override
  Widget build(BuildContext context) {
    final a = accent ?? UiConstants.primaryButtonColor;
    final card = Container(
      padding: padding,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(color: a.withOpacity(dimmed ? 0.06 : 0.16)),
        boxShadow: UiConstants.cardShadow,
        gradient: LinearGradient(
          colors: [
            a.withOpacity(dimmed ? 0.03 : 0.09),
            UiConstants.infoBackgroundColor,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Opacity(opacity: dimmed ? 0.55 : 1, child: child),
    );
    if (onTap == null) return card;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(radius),
      child: card,
    );
  }
}

/// Section title used at the top of every grouped block. Keeps heading rhythm
/// identical across pages.
class SectionHeader extends StatelessWidget {
  final String title;
  final String? trailing; // e.g. "12 topics" / "Last 6 months"
  final IconData? icon;
  final Color? accent;

  const SectionHeader(this.title, {super.key, this.trailing, this.icon, this.accent});

  @override
  Widget build(BuildContext context) {
    final a = accent ?? UiConstants.primaryButtonColor;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
      child: Row(
        children: [
          if (icon != null) ...[
            Icon(icon, size: 18, color: a),
            const SizedBox(width: AppSpacing.xs),
          ],
          Expanded(child: Text(title, style: AppTextStyles.title)),
          if (trailing != null) Text(trailing!, style: AppTextStyles.caption),
        ],
      ),
    );
  }
}

/// Circular progress ring with a centered label. Used for topic %, ladder %,
/// streak day-of-week, goal completion — anywhere a 0..1 ratio is shown.
class ProgressRing extends StatelessWidget {
  final double ratio; // 0..1
  final double size;
  final double stroke;
  final Color? color;
  final Widget? center;

  const ProgressRing({
    super.key,
    required this.ratio,
    this.size = 56,
    this.stroke = 6,
    this.color,
    this.center,
  });

  @override
  Widget build(BuildContext context) {
    final c = color ?? UiConstants.primaryButtonColor;
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            width: size,
            height: size,
            child: CircularProgressIndicator(
              value: ratio.clamp(0, 1),
              strokeWidth: stroke,
              backgroundColor: c.withOpacity(0.12),
              valueColor: AlwaysStoppedAnimation(c),
              strokeCap: StrokeCap.round,
            ),
          ),
          if (center != null) center!,
        ],
      ),
    );
  }
}

/// Compact "label + value" pill. The standard way to show a stat (rating,
/// solved count, streak, rank). Always pair a colored value with a muted label.
class StatPill extends StatelessWidget {
  final String label;
  final String value;
  final Color? color;
  final IconData? icon;

  const StatPill(this.label, this.value, {super.key, this.color, this.icon});

  @override
  Widget build(BuildContext context) {
    final c = color ?? UiConstants.primaryButtonColor;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: AppSpacing.xs),
      decoration: BoxDecoration(
        color: c.withOpacity(0.10),
        borderRadius: BorderRadius.circular(AppRadii.pill),
        border: Border.all(color: c.withOpacity(0.18)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 14, color: c),
            const SizedBox(width: 6),
          ],
          Text('$label ', style: AppTextStyles.caption),
          Text(value, style: AppTextStyles.stat.copyWith(color: c)),
        ],
      ),
    );
  }
}

/// Status chip for enum-like state (topic locked/available/done, upsolve
/// pending/resolved). Icon + word so it never relies on color alone (a11y, see
/// Phase 6.6).
class StatusChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;

  const StatusChip({super.key, required this.label, required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xs, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: AppRadii.rSm,
        border: Border.all(color: color.withOpacity(0.22)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: color),
          const SizedBox(width: 5),
          Text(label,
              style: AppTextStyles.caption.copyWith(color: color, fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }
}
