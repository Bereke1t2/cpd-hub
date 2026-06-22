// lib/core/theme/responsive.dart
//
// Phase 12 — responsive sizing. The app currently hardcodes px everywhere, so
// it looks cramped on small phones (e.g. the itel A667L) and oversized on
// tablets/web. This gives every widget a single, cheap way to scale.
//
// Usage:
//   final r = context.r;            // Responsive helper
//   padding: EdgeInsets.all(r.gap), // density-aware gap
//   style: TextStyle(fontSize: r.sp(14)); // font that scales + respects a11y
//
// Rules:
//   - NEVER read MediaQuery.of(context).size directly in a widget; use context.r.
//   - Clamp text scaling so accessibility large-font users don't break layouts.

import 'package:flutter/material.dart';

enum DeviceClass { compact, medium, expanded } // < 360 / 360–600 / > 600

class Responsive {
  final double width;
  final double textScale;

  const Responsive._(this.width, this.textScale);

  factory Responsive.of(BuildContext context) {
    final mq = MediaQuery.of(context);
    // Clamp OS text scaling to a sane band so huge-font settings can't
    // overflow our dense cards.
    final clamped = mq.textScaler.clamp(minScaleFactor: 0.9, maxScaleFactor: 1.2);
    final scale = clamped.scale(1.0);
    return Responsive._(mq.size.width, scale);
  }

  DeviceClass get device {
    if (width < 360) return DeviceClass.compact;
    if (width <= 600) return DeviceClass.medium;
    return DeviceClass.expanded;
  }

  bool get isCompact => device == DeviceClass.compact;
  bool get isExpanded => device == DeviceClass.expanded;

  /// Density multiplier for spacing/sizing. Small phones get tighter spacing,
  /// large screens get a little more air. Tuned to feel right, not literal.
  double get _k => switch (device) {
        DeviceClass.compact => 0.85,
        DeviceClass.medium => 1.0,
        DeviceClass.expanded => 1.1,
      };

  /// Density-aware gap (base 12 → 10 / 12 / 13).
  double get gap => 12 * _k;

  /// Scale an arbitrary dp value by device density.
  double dp(double v) => v * _k;

  /// Scale a font size by density AND clamped OS text scale.
  double sp(double v) => v * _k * textScale;

  /// Columns for a responsive grid (cards). 1 / 2 / 3.
  int get gridColumns => switch (device) {
        DeviceClass.compact => 1,
        DeviceClass.medium => 1,
        DeviceClass.expanded => 3,
      };

  /// Max content width so wide screens don't stretch a single column edge-to-edge.
  double get contentMaxWidth => isExpanded ? 1100 : double.infinity;
}

extension ResponsiveX on BuildContext {
  Responsive get r => Responsive.of(this);
}
