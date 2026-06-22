import 'package:flutter/material.dart';
import 'package:lab_portal/core/theme/app_colors.dart';
import 'package:lab_portal/core/theme/app_dimens.dart';
import 'package:lab_portal/core/ui_constants.dart';
import 'package:lab_portal/core/widgets/app_card.dart';
import 'package:lab_portal/core/widgets/app_chip.dart';
import 'package:lab_portal/core/widgets/app_text.dart';

class ProblemBox extends StatelessWidget {
  final String title;
  final String difficulty;
  const ProblemBox({super.key, required this.title, required this.difficulty});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
          bottom: AppDimens.sm, left: AppDimens.md, right: AppDimens.md),
      child: AppCard(
        child: Row(
          children: [
            Expanded(
              child: AppText.body(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                color: UiConstants.problemTextColor,
              ),
            ),
            const SizedBox(width: AppDimens.sm),
            AppChip(
              difficulty,
              color: AppColors.difficulty(difficulty),
              backgroundColor: AppColors.difficultyBg(difficulty),
            ),
          ],
        ),
      ),
    );
  }
}
