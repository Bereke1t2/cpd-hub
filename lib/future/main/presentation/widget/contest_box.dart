import 'package:flutter/material.dart';
import 'package:lab_portal/core/theme/app_dimens.dart';
import 'package:lab_portal/core/ui_constants.dart';
import 'package:lab_portal/core/widgets/app_card.dart';
import 'package:lab_portal/core/widgets/app_chip.dart';
import 'package:lab_portal/core/widgets/app_text.dart';

class ContestBox extends StatelessWidget {
  final String title;
  final bool participated;
  final DateTime date;
  final int numberOfProblems;
  final DateTime time;
  final int numberOfContestants;
  final VoidCallback? onTap;

  const ContestBox({
    super.key,
    required this.title,
    required this.participated,
    required this.date,
    required this.numberOfProblems,
    required this.time,
    required this.numberOfContestants,
    this.onTap,
  });

  String _relativeFrom(DateTime d) {
    final diff = DateTime.now().difference(d);
    if (diff.inDays > 0) return '${diff.inDays}d ago';
    if (diff.inHours > 0) return '${diff.inHours}h ago';
    if (diff.inMinutes > 0) return '${diff.inMinutes}m ago';
    return 'just now';
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
          vertical: AppDimens.xs, horizontal: AppDimens.md),
      child: AppCard(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: AppText.title(title,
                      maxLines: 2, overflow: TextOverflow.ellipsis),
                ),
                const SizedBox(width: AppDimens.sm),
                AppChip(
                  participated ? 'Done' : 'Upcoming',
                  color: participated
                      ? UiConstants.primaryButtonColor
                      : UiConstants.subtitleTextColor,
                  icon: participated
                      ? Icons.check_circle_outline
                      : Icons.radio_button_unchecked,
                ),
              ],
            ),
            const SizedBox(height: AppDimens.sm),
            Wrap(
              spacing: AppDimens.md,
              runSpacing: AppDimens.xs,
              children: [
                AppText.caption('$numberOfProblems problems'),
                AppText.caption(_relativeFrom(date)),
                if (numberOfContestants > 0)
                  AppText.caption('$numberOfContestants contestants'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
