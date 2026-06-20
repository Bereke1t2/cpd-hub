import 'package:flutter/material.dart';
import 'package:lab_portal/core/theme/app_radii.dart';
import 'package:lab_portal/core/theme/app_spacing.dart';
import 'package:lab_portal/core/theme/app_text_styles.dart';
import 'package:lab_portal/core/ui_constants.dart';
import '../../domain/entity/topic_strength_entity.dart';

/// Shows per-category average mastery as labelled progress bars.
/// Used on ProfilePage (11.8).
class StrengthCategoryBars extends StatelessWidget {
  final List<TopicStrengthEntity> strengths;

  const StrengthCategoryBars({super.key, required this.strengths});

  @override
  Widget build(BuildContext context) {
    if (strengths.isEmpty) return const SizedBox.shrink();

    // Aggregate by category.
    final byCategory = <String, List<double>>{};
    for (final s in strengths) {
      byCategory.putIfAbsent(s.category, () => []).add(s.mastery);
    }

    final averages = byCategory.map(
      (cat, masteries) => MapEntry(
        cat,
        masteries.reduce((a, b) => a + b) / masteries.length,
      ),
    );

    // Sort weakest first.
    final sorted = averages.entries.toList()
      ..sort((a, b) => a.value.compareTo(b.value));

    return Column(
      children: [
        for (final entry in sorted)
          Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.xs),
            child: _CategoryRow(category: entry.key, ratio: entry.value),
          ),
      ],
    );
  }
}

class _CategoryRow extends StatelessWidget {
  final String category;
  final double ratio;

  const _CategoryRow({required this.category, required this.ratio});

  Color get _color {
    if (ratio >= 0.7) return UiConstants.primaryButtonColor;
    if (ratio >= 0.4) return UiConstants.statTextColor;
    return const Color(0xFFE53935);
  }

  @override
  Widget build(BuildContext context) {
    final pct = (ratio * 100).round();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(child: Text(category, style: AppTextStyles.caption)),
            Text('$pct%',
                style: AppTextStyles.caption
                    .copyWith(color: _color, fontWeight: FontWeight.w700)),
          ],
        ),
        const SizedBox(height: 4),
        ClipRRect(
          borderRadius: BorderRadius.circular(AppRadii.pill),
          child: LinearProgressIndicator(
            value: ratio.clamp(0.0, 1.0),
            minHeight: 6,
            backgroundColor: _color.withOpacity(0.12),
            valueColor: AlwaysStoppedAnimation<Color>(_color),
          ),
        ),
      ],
    );
  }
}
