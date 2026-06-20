import 'package:flutter/material.dart';
import 'package:lab_portal/core/theme/app_spacing.dart';
import 'package:lab_portal/core/theme/app_text_styles.dart';
import 'package:lab_portal/core/ui_constants.dart';
import 'package:lab_portal/core/widgets/ui_kit.dart';
import '../../domain/entity/review_item_entity.dart';

class ReviewTile extends StatelessWidget {
  final ReviewItemEntity item;
  final String problemTitle;
  final VoidCallback onTap;
  final VoidCallback onGotIt;
  final VoidCallback onForgot;

  const ReviewTile({
    super.key,
    required this.item,
    required this.problemTitle,
    required this.onTap,
    required this.onGotIt,
    required this.onForgot,
  });

  @override
  Widget build(BuildContext context) {
    return GradientCard(
      accent: UiConstants.ratingTextColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.refresh_rounded,
                  size: 16, color: UiConstants.ratingTextColor),
              const SizedBox(width: 6),
              Expanded(
                child: GestureDetector(
                  onTap: onTap,
                  child: Text(problemTitle, style: AppTextStyles.title),
                ),
              ),
              StatusChip(
                label: 'Review',
                icon: Icons.schedule_rounded,
                color: UiConstants.ratingTextColor,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            'Interval: ${item.interval}d · Repetition #${item.repetitions + 1}',
            style: AppTextStyles.caption,
          ),
          const SizedBox(height: AppSpacing.sm),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: onGotIt,
                  icon: const Icon(Icons.check_rounded,
                      size: 16, color: UiConstants.primaryButtonColor),
                  label: const Text('Got it',
                      style: TextStyle(color: UiConstants.primaryButtonColor)),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(
                        color: UiConstants.primaryButtonColor, width: 1),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.xs),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: onForgot,
                  icon: const Icon(Icons.close_rounded,
                      size: 16, color: UiConstants.subtitleTextColor),
                  label: const Text('Forgot',
                      style: TextStyle(color: UiConstants.subtitleTextColor)),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(
                        color: UiConstants.subtitleTextColor, width: 1),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
