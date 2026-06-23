// lib/future/main/presentation/widget/contest_card.dart
//
// Contest list card. Shows a platform badge + title + meta, plus:
//   • upcoming → an animated HH:MM:SS countdown that reddens as it nears,
//   • live     → a pulsing LIVE badge and an "ends in" countdown,
//   • past     → the relative finish time.

import 'package:flutter/material.dart';
import 'package:lab_portal/core/theme/app_dimens.dart';
import 'package:lab_portal/core/ui_constants.dart';
import 'package:lab_portal/core/widgets/app_card.dart';
import 'package:lab_portal/core/widgets/app_chip.dart';
import 'package:lab_portal/core/widgets/app_text.dart';
import 'package:lab_portal/future/main/domain/entity/contest_entity.dart';
import 'package:lab_portal/future/main/presentation/widget/contest_countdown.dart';

class ContestCard extends StatefulWidget {
  final ContestEntity contest;
  final VoidCallback? onTap;

  const ContestCard({super.key, required this.contest, this.onTap});

  @override
  State<ContestCard> createState() => _ContestCardState();
}

class _ContestCardState extends State<ContestCard> {
  // Bumped when a countdown elapses so the card re-derives its phase
  // (upcoming → live → past) from the entity's time-based getters.
  int _tick = 0;

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
    final isLive = c.isRunning;
    final isUpcoming = c.isUpcoming;

    return Padding(
      padding: const EdgeInsets.symmetric(
          vertical: AppDimens.xs, horizontal: AppDimens.md),
      child: AppCard(
        accent: isLive ? _live : platformColor,
        onTap: widget.onTap,
        isolate: true,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header row: platform + participation chips (wrap if cramped) and
            // the status pinned right.
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Wrap(
                    spacing: AppDimens.sm,
                    runSpacing: AppDimens.xs,
                    children: [
                      AppChip(c.platform, color: platformColor),
                      if (c.isParticipating)
                        const AppChip('Joined',
                            color: UiConstants.primaryButtonColor,
                            icon: Icons.check_circle_outline),
                    ],
                  ),
                ),
                const SizedBox(width: AppDimens.sm),
                if (isLive)
                  const _LiveBadge()
                else if (!isUpcoming)
                  AppText.caption(_relativeFrom(c.startsAt)),
              ],
            ),
            const SizedBox(height: AppDimens.sm),
            AppText.title(c.title, maxLines: 2, overflow: TextOverflow.ellipsis),
            const SizedBox(height: AppDimens.xs),
            Wrap(
              spacing: AppDimens.md,
              runSpacing: AppDimens.xs,
              children: [
                if (c.numberOfProblems > 0)
                  AppText.caption('${c.numberOfProblems} problems'),
                AppText.caption(
                  isUpcoming || isLive
                      ? _fmtDate(c.startsAt)
                      : _relativeFrom(c.startsAt),
                ),
              ],
            ),
            // Countdown panel for live + upcoming contests.
            if (isLive || isUpcoming) ...[
              const SizedBox(height: AppDimens.md),
              _CountdownPanel(
                key: ValueKey('cd-$_tick-${isLive ? 'live' : 'soon'}'),
                accent: isLive ? _live : UiConstants.primaryButtonColor,
                label: isLive ? 'ENDS IN' : 'STARTS IN',
                live: isLive,
                target: isLive ? c.endsAt : c.startsAt,
                onElapsed: () {
                  if (mounted) setState(() => _tick++);
                },
              ),
            ],
          ],
        ),
      ),
    );
  }

  String _fmtDate(DateTime d) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${months[d.month - 1]} ${d.day}, ${d.hour.toString().padLeft(2, '0')}:${d.minute.toString().padLeft(2, '0')}';
  }
}

// Warm "live" accent used for running contests.
const Color _live = Color(0xFFF44336);

// ── Countdown panel (label + animated timer) ─────────────────────────────────
class _CountdownPanel extends StatelessWidget {
  final Color accent;
  final String label;
  final bool live;
  final DateTime target;
  final VoidCallback onElapsed;

  const _CountdownPanel({
    super.key,
    required this.accent,
    required this.label,
    required this.live,
    required this.target,
    required this.onElapsed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppDimens.md),
      decoration: BoxDecoration(
        color: UiConstants.backgroundColor.withValues(alpha: 0.45),
        borderRadius: AppDimens.brMd,
        border: Border.all(color: accent.withValues(alpha: 0.18)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                live ? Icons.sensors_rounded : Icons.timer_outlined,
                size: AppDimens.iconSm,
                color: accent,
              ),
              const SizedBox(width: AppDimens.xs),
              Text(
                label,
                style: TextStyle(
                  color: accent,
                  fontSize: AppDimens.fCaption,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.8,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppDimens.sm),
          ContestCountdown(target: target, onElapsed: onElapsed),
        ],
      ),
    );
  }
}

// ── Pulsing "LIVE" badge ─────────────────────────────────────────────────────
class _LiveBadge extends StatefulWidget {
  const _LiveBadge();

  @override
  State<_LiveBadge> createState() => _LiveBadgeState();
}

class _LiveBadgeState extends State<_LiveBadge>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1100),
  )..repeat(reverse: true);

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: AppDimens.sm, vertical: AppDimens.xs),
      decoration: BoxDecoration(
        color: _live.withValues(alpha: 0.14),
        borderRadius: const BorderRadius.all(Radius.circular(AppDimens.rPill)),
        border: Border.all(color: _live.withValues(alpha: 0.40)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          FadeTransition(
            opacity: Tween<double>(begin: 0.35, end: 1).animate(_c),
            child: Container(
              width: 8,
              height: 8,
              decoration: const BoxDecoration(
                color: _live,
                shape: BoxShape.circle,
              ),
            ),
          ),
          const SizedBox(width: AppDimens.xs),
          const Text(
            'LIVE',
            style: TextStyle(
              color: _live,
              fontSize: AppDimens.fCaption,
              fontWeight: FontWeight.w900,
              letterSpacing: 0.8,
            ),
          ),
        ],
      ),
    );
  }
}
