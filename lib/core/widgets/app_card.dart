// lib/core/widgets/app_card.dart
//
// Phase 12/13 — the performance-correct replacement for GradientCard.
//
// WHY the app lags: the existing GradientCard wraps EVERY child in Opacity()
// even at 1.0. Opacity forces saveLayer() — an offscreen composite — on every
// card, every frame. With long lists this tanks scroll FPS.
//
// Fixes here:
//   - Opacity is only inserted when actually dimmed (< 1.0).
//   - Optional `isolate: true` wraps the card in RepaintBoundary so it doesn't
//     repaint siblings in scrolling lists.
//
// Migration: replace GradientCard usages with AppCard. Same constructor shape.

import 'package:flutter/material.dart';
import 'package:lab_portal/core/theme/app_dimens.dart';
import 'package:lab_portal/core/ui_constants.dart';

class AppCard extends StatelessWidget {
  final Widget child;
  final Color? accent;
  final EdgeInsetsGeometry padding;
  final double radius;
  final VoidCallback? onTap;
  final bool dimmed;

  /// Wrap in a RepaintBoundary — use for list/grid items so each card paints
  /// independently. Default false to avoid boundary overhead on one-off cards.
  final bool isolate;

  const AppCard({
    super.key,
    required this.child,
    this.accent,
    this.padding = AppDimens.cardPadding,
    this.radius = AppDimens.rMd,
    this.onTap,
    this.dimmed = false,
    this.isolate = false,
  });

  @override
  Widget build(BuildContext context) {
    final a = accent ?? UiConstants.primaryButtonColor;

    Widget content = Container(
      padding: padding,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(color: a.withValues(alpha: dimmed ? 0.06 : 0.16)),
        boxShadow: UiConstants.cardShadow,
        gradient: LinearGradient(
          colors: [
            a.withValues(alpha: dimmed ? 0.03 : 0.09),
            UiConstants.infoBackgroundColor,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: child,
    );

    // Only pay for an Opacity layer when we actually need to dim.
    if (dimmed) {
      content = Opacity(opacity: 0.55, child: content);
    }

    if (onTap != null) {
      content = InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(radius),
        child: content,
      );
    }

    if (isolate) {
      content = RepaintBoundary(child: content);
    }
    return content;
  }
}
