// Shared building blocks for phases 9–11.
// Every new screen is assembled from these — never hand-roll a card decoration.

import 'package:flutter/material.dart';
import 'package:lab_portal/core/theme/app_radii.dart';
import 'package:lab_portal/core/theme/app_spacing.dart';
import 'package:lab_portal/core/theme/app_text_styles.dart';
import 'package:lab_portal/core/ui_constants.dart';

/// The canonical dark surface card. Gradient tint is pulled from [accent],
/// which must carry semantic meaning (topic status, difficulty, etc.).
class GradientCard extends StatelessWidget {
  final Widget child;
  final Color? accent;
  final EdgeInsetsGeometry padding;
  final double radius;
  final VoidCallback? onTap;
  final bool dimmed;

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
      child: Opacity(opacity: dimmed ? 0.55 : 1.0, child: child),
    );
    if (onTap == null) return card;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(radius),
      child: card,
    );
  }
}

/// Consistent section heading with optional trailing text and icon.
class SectionHeader extends StatelessWidget {
  final String title;
  final String? trailing;
  final IconData? icon;
  final Color? accent;

  const SectionHeader(
    this.title, {
    super.key,
    this.trailing,
    this.icon,
    this.accent,
  });

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

/// Circular progress ring with a centered child (number, icon, etc.).
class ProgressRing extends StatelessWidget {
  final double ratio;
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
              value: ratio.clamp(0.0, 1.0),
              strokeWidth: stroke,
              backgroundColor: c.withOpacity(0.12),
              valueColor: AlwaysStoppedAnimation<Color>(c),
              strokeCap: StrokeCap.round,
            ),
          ),
          if (center != null) center!,
        ],
      ),
    );
  }
}

/// Compact "label + value" stat pill. Pair a colored value with a muted label.
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
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
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
          Text('$label  ', style: AppTextStyles.caption),
          Text(value, style: AppTextStyles.stat.copyWith(color: c)),
        ],
      ),
    );
  }
}

/// Enum-state chip — icon + label so colour never stands alone (a11y).
class StatusChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;

  const StatusChip({
    super.key,
    required this.label,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.xs,
        vertical: 4,
      ),
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
          Text(
            label,
            style: AppTextStyles.caption
                .copyWith(color: color, fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }
}
