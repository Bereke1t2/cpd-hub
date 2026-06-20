import 'package:flutter/material.dart';
import 'package:lab_portal/core/theme/app_spacing.dart';
import 'package:lab_portal/core/theme/app_text_styles.dart';
import 'package:lab_portal/core/ui_constants.dart';
import 'package:lab_portal/core/widgets/ui_kit.dart';
import '../../domain/entity/track_entity.dart';

class TrackCard extends StatelessWidget {
  final TrackEntity track;
  final double completion; // 0..1
  final VoidCallback onTap;

  const TrackCard({
    super.key,
    required this.track,
    required this.completion,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final pct = (completion * 100).round();
    return GradientCard(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: UiConstants.primaryButtonColor.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  _icon(track.iconName),
                  color: UiConstants.primaryButtonColor,
                  size: 20,
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(track.title, style: AppTextStyles.title),
                    const SizedBox(height: 2),
                    Text(
                      '${track.topicIds.length} topics',
                      style: AppTextStyles.caption,
                    ),
                  ],
                ),
              ),
              StatPill(
                'Done',
                '$pct%',
                color: pct == 100
                    ? UiConstants.primaryButtonColor
                    : UiConstants.statTextColor,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: LinearProgressIndicator(
              value: completion.clamp(0.0, 1.0),
              minHeight: 6,
              backgroundColor:
                  UiConstants.primaryButtonColor.withOpacity(0.12),
              valueColor: const AlwaysStoppedAnimation<Color>(
                UiConstants.primaryButtonColor,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(track.description, style: AppTextStyles.caption, maxLines: 2),
        ],
      ),
    );
  }

  IconData _icon(String name) {
    switch (name) {
      case 'bolt':
        return Icons.bolt_rounded;
      case 'account_tree':
        return Icons.account_tree_rounded;
      case 'layers':
        return Icons.layers_rounded;
      case 'functions':
        return Icons.functions_rounded;
      default:
        return Icons.school_rounded;
    }
  }
}
