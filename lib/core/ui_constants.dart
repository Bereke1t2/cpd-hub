import 'package:flutter/material.dart';

class UiConstants {
  // Background Colors
  static const Color backgroundColor = Color(0xFF121212); // Dark background
  static final Color cardBackgroundColor = Color.lerp(
    UiConstants.backgroundColor,
    UiConstants.primaryButtonColor,
    0.28,
  )!; // Slightly lighter for cards and sections
  // Primary Colors
  static const Color primaryButtonColor = Color(
    0xFF28C76F,
  ); // Bright Green (for buttons like 'Solve It Now')
  static const Color secondaryButtonColor = Color(
    0xFF5B6C8E,
  ); // Light Blue (for other highlighted sections)
  static const Color infoBackgroundColor = Color(
    0xFF1A2A3A,
  ); // Darker shade for info sections

  // Text Colors
  static const Color mainTextColor = Color(0xFFFFFFFF); // White text
  static const Color subtitleTextColor = Color(
    0xFFB0B0B0,
  ); // Light gray for secondary text
  static const Color problemTextColor = Color(
    0xFF58B4D8,
  ); // Light blue text for problem info

  // Rating & Stats
  static const Color ratingTextColor = Color(
    0xFFE9A200,
  ); // Gold/yellow for rating text
  static const Color statTextColor = Color(
    0xFF00C1A1,
  ); // Green text for statistics

  // Problem Difficulty Colors
  static const Color easyProblemColor = Color(
    0x334CAF50,
  ); // 20% transparent green (easy problem)
  static const Color mediumProblemColor = Color(
    0x33FFC107,
  ); // 20% transparent yellow (medium problem)
  static const Color hardProblemColor = Color(
    0x33F44336,
  ); // 20% transparent red (hard problem)

  // Borders and Shadows
  static const Color borderColor = Color(
    0xFF333333,
  ); // Dark border color for cards and sections
  static const Color shadowColor = Color(
    0x80000000,
  ); // Semi-transparent black for shadows

  static Color getUserRatingColor(int rating) {
    if (rating < 1200) return Colors.grey;
    if (rating < 1400) return Colors.green;
    if (rating < 1600) return Colors.cyan;
    if (rating < 1900) return Colors.blue;
    if (rating < 2100) return Colors.purple;
    if (rating < 2400) return Colors.orange;
    return Colors.red;
  }
}
