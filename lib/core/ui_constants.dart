import 'package:flutter/material.dart';

class UiConstants {
  // ── Backgrounds ───────────────────────────────────────────────────────────
  static const Color backgroundColor = Color(0xFF0D1F17); // deep dark-green tint
  static const Color infoBackgroundColor = Color(0xFF152B1E); // card surface
  static final Color cardBackgroundColor = Color.lerp(
    infoBackgroundColor,
    primaryButtonColor,
    0.18,
  )!;

  // ── Primary palette: green + white ────────────────────────────────────────
  static const Color primaryButtonColor = Color(0xFF28C76F); // green
  static const Color primaryDark = Color(0xFF1B7A49); // deeper green (gradients)

  // ── Text ──────────────────────────────────────────────────────────────────
  static const Color mainTextColor = Color(0xFFFFFFFF); // white
  static const Color subtitleTextColor = Color(0xFFAABBAA); // muted green-grey

  // Keep these aliases pointing at primary so widgets that reference them
  // stay green without needing a mass find-replace yet.
  static const Color problemTextColor = Color(0xFFFFFFFF); // white (was blue)
  static const Color ratingTextColor = Color(0xFF28C76F); // green (was gold)
  static const Color statTextColor = Color(0xFF28C76F); // green (was teal)
  static const Color secondaryButtonColor = Color(0xFF28C76F); // green (was blue-grey)

  // ── Difficulty (semantic — keep distinct) ─────────────────────────────────
  static const Color easyProblemColor = Color(0x2228C76F); // green tint
  static const Color mediumProblemColor = Color(0x22FFC107); // amber tint
  static const Color hardProblemColor = Color(0x22F44336); // red tint

  // ── Borders & shadows ─────────────────────────────────────────────────────
  static const Color borderColor = Color(0xFF1E3D2A);
  static const Color shadowColor = Color(0x80000000);

  static const List<BoxShadow> cardShadow = [
    BoxShadow(color: shadowColor, blurRadius: 10, offset: Offset(0, 4)),
  ];
  static Border get cardBorder => Border.all(color: borderColor);

  // ── Rating tier colors (kept for competitive context) ────────────────────
  static Color getUserRatingColor(int rating) {
    if (rating >= 2000) return const Color(0xFFFF5722);
    if (rating >= 1500) return const Color(0xFFFF9800);
    if (rating >= 1000) return const Color(0xFFFFEB3B);
    return primaryButtonColor;
  }
}
