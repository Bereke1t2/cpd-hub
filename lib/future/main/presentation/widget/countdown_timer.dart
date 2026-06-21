// lib/future/main/presentation/widget/countdown_timer.dart
//
// Phase 16 — a live countdown to an upcoming contest start time.
//
// Performance: a naive Timer.periodic(1s) that calls setState on a big widget
// repaints the whole subtree every second. This widget isolates the ticking
// text in its own StatefulWidget + RepaintBoundary so only the digits repaint,
// never the surrounding card.

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:lab_portal/core/theme/app_dimens.dart';
import 'package:lab_portal/core/ui_constants.dart';

class CountdownTimer extends StatefulWidget {
  /// Contest start time (already in local timezone via ContestEntity.startsAt).
  final DateTime target;

  /// Called once when the countdown reaches zero.
  final VoidCallback? onElapsed;

  final TextStyle? style;

  const CountdownTimer({
    super.key,
    required this.target,
    this.onElapsed,
    this.style,
  });

  @override
  State<CountdownTimer> createState() => _CountdownTimerState();
}

class _CountdownTimerState extends State<CountdownTimer> {
  Timer? _timer;
  late Duration _remaining;
  bool _firedElapsed = false;

  @override
  void initState() {
    super.initState();
    _recompute();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => _recompute());
  }

  void _recompute() {
    final left = widget.target.difference(DateTime.now());
    if (left.isNegative) {
      _timer?.cancel();
      if (!_firedElapsed) {
        _firedElapsed = true;
        widget.onElapsed?.call();
      }
      if (mounted) setState(() => _remaining = Duration.zero);
      return;
    }
    if (mounted) setState(() => _remaining = left);
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String _fmt() {
    if (_remaining == Duration.zero) return 'Live now';
    final d = _remaining.inDays;
    final h = _remaining.inHours % 24;
    final m = _remaining.inMinutes % 60;
    final s = _remaining.inSeconds % 60;
    if (d > 0) return '${d}d ${h}h ${m}m';
    if (h > 0) return '${h}h ${m}m ${s}s';
    return '${m}m ${s}s';
  }

  @override
  Widget build(BuildContext context) {
    final isSoon =
        _remaining.inHours < 1 && _remaining != Duration.zero;
    final accent = isSoon
        ? UiConstants.ratingTextColor
        : UiConstants.primaryButtonColor;

    return RepaintBoundary(
      child: Container(
        padding: const EdgeInsets.symmetric(
            horizontal: AppDimens.sm, vertical: AppDimens.xs),
        decoration: BoxDecoration(
          color: accent.withValues(alpha: 0.12),
          borderRadius: AppDimens.brSm,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              _remaining == Duration.zero
                  ? Icons.circle
                  : Icons.timer_outlined,
              size: AppDimens.iconSm,
              color: accent,
            ),
            const SizedBox(width: AppDimens.xs),
            Text(
              _fmt(),
              style: widget.style ??
                  TextStyle(
                    color: accent,
                    fontWeight: FontWeight.w700,
                    fontSize: AppDimens.fCaption,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
