import 'package:flutter/material.dart';
import 'package:lab_portal/core/theme/app_colors.dart';
import 'package:lab_portal/core/theme/app_dimens.dart';
import 'package:lab_portal/core/ui_constants.dart';
import 'package:lab_portal/core/widgets/app_card.dart';
import 'package:lab_portal/core/widgets/app_chip.dart';
import 'package:lab_portal/core/widgets/app_text.dart';
import 'package:lab_portal/core/widgets/primary_button.dart';
import 'package:lab_portal/future/main/presentation/widget/liked_and_dis_button.dart';

class TodaysProblemBox extends StatelessWidget {
  final bool isLiked;
  final bool isDisliked;
  final String problemTitle;
  final double solved;
  final List<String> tags;
  final double liked;
  final double disliked;
  final String difficulty;

  const TodaysProblemBox({
    super.key,
    required this.problemTitle,
    required this.solved,
    required this.tags,
    required this.liked,
    required this.disliked,
    required this.difficulty,
    required this.isLiked,
    required this.isDisliked,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
          bottom: AppDimens.md, left: AppDimens.md, right: AppDimens.md),
      child: AppCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: AppText.h2("Today's Daily Problem"),
                ),
                AppChip(
                  difficulty,
                  color: AppColors.difficulty(difficulty),
                  backgroundColor: AppColors.difficultyBg(difficulty),
                ),
              ],
            ),
            const SizedBox(height: AppDimens.md),
            AppText.body(problemTitle),
            const SizedBox(height: AppDimens.sm),
            if (tags.isNotEmpty)
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: tags
                      .map((t) => Padding(
                            padding:
                                const EdgeInsets.only(right: AppDimens.xs),
                            child: AppChip(t,
                                color: UiConstants.secondaryButtonColor),
                          ))
                      .toList(),
                ),
              ),
            const SizedBox(height: AppDimens.sm),
            Row(
              children: [
                AppText.caption(
                    'Solved: ${solved.toStringAsFixed(0)} students',
                    color: UiConstants.statTextColor),
                const Spacer(),
                LikedAndDislikedButtons(
                  isLiked: isLiked,
                  isDisliked: isDisliked,
                  likedCount: liked.toInt(),
                  dislikedCount: disliked.toInt(),
                  onLike: () {},
                  onDislike: () {},
                ),
              ],
            ),
            const SizedBox(height: AppDimens.md),
            PrimaryButton(title: 'View Details', onPressed: () {}),
          ],
        ),
      ),
    );
  }
}
