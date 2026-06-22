// lib/core/theme/app_colors.dart
//
// Phase 13 — single source of semantic colors. No widget may use inline
// Color(0xFF...) for difficulty/rating/status — call these helpers instead.
// Keeps colors consistent across difficulty chips, problem rows, user cards, etc.

import 'package:flutter/material.dart';
import 'package:lab_portal/core/ui_constants.dart';

class AppColors {
  AppColors._();

  // ── Difficulty ─────────────────────────────────────────────────────────────
  static Color difficulty(String level) {
    switch (level.toLowerCase()) {
      case 'easy':
        return const Color(0xFF4CAF50);
      case 'medium':
        return const Color(0xFFFFC107);
      case 'hard':
        return const Color(0xFFF44336);
      default:
        return UiConstants.subtitleTextColor;
    }
  }

  static Color difficultyBg(String level) {
    switch (level.toLowerCase()) {
      case 'easy':
        return UiConstants.easyProblemColor;
      case 'medium':
        return UiConstants.mediumProblemColor;
      case 'hard':
        return UiConstants.hardProblemColor;
      default:
        return UiConstants.infoBackgroundColor;
    }
  }

  // ── Rating tier ────────────────────────────────────────────────────────────
  static Color rating(int r) {
    if (r >= 2400) return const Color(0xFFFF0000);
    if (r >= 2000) return const Color(0xFFFF8F00);
    if (r >= 1900) return const Color(0xFF7E57C2);
    if (r >= 1600) return const Color(0xFF1E88E5);
    if (r >= 1400) return const Color(0xFF00BCD4);
    if (r >= 1200) return const Color(0xFF43A047);
    return const Color(0xFF9E9E9E);
  }

  // ── Topic / learning status ─────────────────────────────────────────────────
  static Color topicStatus(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
        return UiConstants.primaryButtonColor;
      case 'in_progress':
      case 'in progress':
        return UiConstants.ratingTextColor;
      case 'locked':
        return UiConstants.subtitleTextColor;
      default:
        return UiConstants.secondaryButtonColor;
    }
  }
}
