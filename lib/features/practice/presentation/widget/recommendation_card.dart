import 'package:flutter/material.dart';
import 'package:lab_portal/core/theme/app_radii.dart';
import 'package:lab_portal/core/theme/app_spacing.dart';
import 'package:lab_portal/core/theme/app_text_styles.dart';
import 'package:lab_portal/core/ui_constants.dart';
import 'package:lab_portal/core/widgets/ui_kit.dart';
import '../../domain/entity/recommendation_entity.dart';

class RecommendationCard extends StatelessWidget {
  final RecommendationEntity rec;
  final VoidCallback onTap;
  final VoidCallback? onAddToReview;

  const RecommendationCard({
    super.key,
    required this.rec,
    required this.onTap,
    this.onAddToReview,
  });

  Color _diffColor(String d) {
    switch (d.toLowerCase()) {
      case 'easy':   return const Color(0xFF43A047);
      case 'medium': return const Color(0xFFFFA726);
      case 'hard':   return const Color(0xFFE53935);
      default:       return UiConstants.subtitleTextColor;
    }
  }

  @override
  Widget build(BuildContext context) {
    final diffColor = _diffColor(rec.difficulty);
    return GradientCard(
      onTap: onTap,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Difficulty badge
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: diffColor.withOpacity(0.12),
              borderRadius: AppRadii.rSm,
              border: Border.all(color: diffColor.withOpacity(0.22)),
            ),
            child: Center(
              child: Text(
                rec.difficulty[0],
                style: TextStyle(
                  color: diffColor,
                  fontWeight: FontWeight.w900,
                  fontSize: 18,
                ),
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  rec.problemId
                      .replaceAll('-', ' ')
                      .split(' ')
                      .map((w) => w.isEmpty
                          ? ''
                          : '${w[0].toUpperCase()}${w.substring(1)}')
                      .join(' '),
                  style: AppTextStyles.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    const Icon(Icons.school_outlined,
                        size: 12, color: UiConstants.subtitleTextColor),
                    const SizedBox(width: 4),
                    Text(rec.topicName, style: AppTextStyles.caption),
                  ],
                ),
                const SizedBox(height: AppSpacing.xs),
                // reason — always shown
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: UiConstants.primaryButtonColor.withOpacity(0.08),
                    borderRadius: AppRadii.rSm,
                  ),
                  child: Text(
                    rec.reason,
                    style: AppTextStyles.caption.copyWith(
                      color: UiConstants.primaryButtonColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (onAddToReview != null)
            IconButton(
              onPressed: onAddToReview,
              tooltip: 'Add to review queue',
              icon: const Icon(Icons.bookmark_add_outlined,
                  color: UiConstants.subtitleTextColor, size: 20),
            ),
        ],
      ),
    );
  }
}

