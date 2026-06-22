import 'package:flutter/material.dart';
import 'package:lab_portal/core/theme/app_colors.dart';
import 'package:lab_portal/core/widgets/app_chip.dart';

/// Thin wrapper kept for backward-compat. Prefer AppChip(difficulty, color: AppColors.difficulty(...)) directly.
class DifficultyBox extends StatelessWidget {
  final String difficulty;

  const DifficultyBox({super.key, required this.difficulty});

  @override
  Widget build(BuildContext context) {
    return AppChip(
      difficulty,
      color: AppColors.difficulty(difficulty),
      backgroundColor: AppColors.difficultyBg(difficulty),
    );
  }
}
