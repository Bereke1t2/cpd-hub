// lib/future/main/presentation/widget/contest_card.dart
//
// Phase 16 — replaces the hand-rolled ContestBox for the contests list.
// Shows: platform badge, title, countdown (upcoming) or date (past),
// participation chip, problem count.

import 'package:flutter/material.dart';
import 'package:lab_portal/core/theme/app_dimens.dart';
import 'package:lab_portal/core/ui_constants.dart';
import 'package:lab_portal/core/widgets/app_card.dart';
import 'package:lab_portal/core/widgets/app_chip.dart';
import 'package:lab_portal/core/widgets/app_text.dart';
import 'package:lab_portal/future/main/domain/entity/contest_entity.dart';
import 'package:lab_portal/future/main/presentation/widget/countdown_timer.dart';

class ContestCard extends StatefulWidget {
  final ContestEntity contest;
  final VoidCallback? onTap;

  const ContestCard({super.key, required this.contest, this.onTap});

  @override
  State<ContestCard> createState() => _ContestCardState();
}

class _ContestCardState extends State<ContestCard> {
  // Flip to true when the countdown fires onElapsed.
  bool _isLive = false;

  Color _platformColor(String platform) {
    switch (platform.toLowerCase()) {
      case 'codeforces':
        return const Color(0xFF1976D2);
      case 'leetcode':
        return const Color(0xFFFFA726);
      case 'atcoder':
        return const Color(0xFF7E57C2);
      case 'codechef':
        return const Color(0xFF5D4037);
      default:
        return UiConstants.secondaryButtonColor;
    }
  }

  String _relativeFrom(DateTime d) {
    final diff = DateTime.now().difference(d);
    if (diff.inDays > 0) return '${diff.inDays}d ago';
    if (diff.inHours > 0) return '${diff.inHours}h ago';
    if (diff.inMinutes > 0) return '${diff.inMinutes}m ago';
    return 'just now';
  }

  @override
  Widget build(BuildContext context) {
    final c = widget.contest;
    final platformColor = _platformColor(c.platform);
    final isUpcoming = c.isUpcoming || _isLive;

    return Padding(
      padding: const EdgeInsets.symmetric(
          vertical: AppDimens.xs, horizontal: AppDimens.md),
      child: AppCard(
        accent: platformColor,
        onTap: widget.onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header row: platform chip + participation status
            Row(
              children: [
                AppChip(c.platform, color: platformColor),
                const SizedBox(width: AppDimens.sm),
                if (c.isParticipating)
                  const AppChip('Joined',
                      color: UiConstants.primaryButtonColor,
                      icon: Icons.check_circle_outline),
                const Spacer(),
                if (_isLive)
                  const AppChip('Live now',
                      color: UiConstants.ratingTextColor,
                      icon: Icons.circle)
                else if (isUpcoming)
                  CountdownTimer(
                    target: c.startsAt,
                    onElapsed: () => setState(() => _isLive = true),
                  )
                else
                  AppText.caption(_relativeFrom(c.startsAt)),
              ],
            ),
            const SizedBox(height: AppDimens.sm),
            // Title
            AppText.title(c.title, maxLines: 2, overflow: TextOverflow.ellipsis),
            const SizedBox(height: AppDimens.xs),
            // Meta row
            Wrap(
              spacing: AppDimens.md,
              runSpacing: AppDimens.xs,
              children: [
                if (c.numberOfProblems > 0)
                  AppText.caption('${c.numberOfProblems} problems'),
                AppText.caption(
                  isUpcoming
                      ? _fmtDate(c.startsAt)
                      : _relativeFrom(c.startsAt),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _fmtDate(DateTime d) {
    final months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${months[d.month - 1]} ${d.day}, ${d.hour.toString().padLeft(2, '0')}:${d.minute.toString().padLeft(2, '0')}';
  }
}
