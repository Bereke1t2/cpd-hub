// lib/future/main/presentation/widget/contest_countdown.dart
//
// A segmented HH:MM:SS (with an optional DAYS segment) countdown that:
//  • flips each digit with a slide/fade as it changes,
//  • ramps its colour green → amber → red as the target approaches,
//  • gently pulses in the final minutes so an imminent start grabs the eye.
//
// Performance: only this widget's subtree repaints each second (it sits in a
// RepaintBoundary), never the card around it.

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:lab_portal/core/theme/app_dimens.dart';
import 'package:lab_portal/core/ui_constants.dart';

class ContestCountdown extends StatefulWidget {
  /// The moment to count down to (start time for upcoming, end time for live).
  final DateTime target;

  /// Fired once when the countdown reaches zero.
  final VoidCallback? onElapsed;

  const ContestCountdown({super.key, required this.target, this.onElapsed});

  @override
  State<ContestCountdown> createState() => _ContestCountdownState();
}

class _ContestCountdownState extends State<ContestCountdown>
    with SingleTickerProviderStateMixin {
  static const _green = UiConstants.primaryButtonColor;
  static const _amber = Color(0xFFFFC107);
  static const _red = Color(0xFFF44336);

  // Colour ramps over the final 6 hours; pulse kicks in under 5 minutes.
  static const _rampSeconds = 6 * 3600;
  static const _urgentSeconds = 5 * 60;

  Timer? _timer;
  late Duration _remaining;
  bool _fired = false;

  late final AnimationController _pulse = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 900),
  );

  @override
  void initState() {
    super.initState();
    _recompute();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => _recompute());
  }

  void _recompute() {
    final left = widget.target.difference(DateTime.now());
    final next = left.isNegative ? Duration.zero : left;

    if (next == Duration.zero) {
      _timer?.cancel();
      if (!_fired) {
        _fired = true;
        widget.onElapsed?.call();
      }
    }

    // Drive the pulse only while urgent — keeps it idle (and cheap) otherwise.
    final urgent = next > Duration.zero && next.inSeconds <= _urgentSeconds;
    if (urgent && !_pulse.isAnimating) {
      _pulse.repeat(reverse: true);
    } else if (!urgent && _pulse.isAnimating) {
      _pulse.stop();
      _pulse.value = 0;
    }

    if (mounted) setState(() => _remaining = next);
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pulse.dispose();
    super.dispose();
  }

  Color get _color {
    final s = _remaining.inSeconds;
    if (s <= 0) return _red;
    final t = (1 - (s / _rampSeconds)).clamp(0.0, 1.0);
    return t < 0.5
        ? Color.lerp(_green, _amber, t / 0.5)!
        : Color.lerp(_amber, _red, (t - 0.5) / 0.5)!;
  }

  String _two(int v) => v.toString().padLeft(2, '0');

  @override
  Widget build(BuildContext context) {
    final color = _color;
    final d = _remaining.inDays;
    final h = _remaining.inHours % 24;
    final m = _remaining.inMinutes % 60;
    final s = _remaining.inSeconds % 60;

    final segments = <Widget>[
      if (d > 0) ...[
        _segment(_two(d), 'DAYS', color),
        _separator(color),
      ],
      _segment(_two(h), 'HRS', color),
      _separator(color),
      _segment(_two(m), 'MIN', color),
      _separator(color),
      _segment(_two(s), 'SEC', color),
    ];

    final row = Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: segments,
    );

    return RepaintBoundary(
      // scaleDown keeps the whole H:M:S strip on one line regardless of the
      // device text scale or how many segments are shown.
      child: FittedBox(
        fit: BoxFit.scaleDown,
        alignment: Alignment.centerLeft,
        child: AnimatedBuilder(
        animation: _pulse,
        builder: (context, child) {
          // 1.0 → 1.04 scale + soft glow while urgent.
          final t = Curves.easeInOut.transform(_pulse.value);
          return Transform.scale(
            scale: 1 + 0.04 * t,
            alignment: Alignment.centerLeft,
            child: DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: AppDimens.brSm,
                boxShadow: [
                  if (t > 0)
                    BoxShadow(
                      color: color.withValues(alpha: 0.35 * t),
                      blurRadius: 14 * t,
                    ),
                ],
              ),
              child: child,
            ),
          );
        },
        child: row,
        ),
      ),
    );
  }

  Widget _segment(String value, String label, Color color) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 400),
          width: 46,
          padding: const EdgeInsets.symmetric(vertical: AppDimens.sm),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.14),
            borderRadius: AppDimens.brSm,
            border: Border.all(color: color.withValues(alpha: 0.32)),
          ),
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 320),
            transitionBuilder: (child, anim) => ClipRect(
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0, 0.45),
                  end: Offset.zero,
                ).animate(anim),
                child: FadeTransition(opacity: anim, child: child),
              ),
            ),
            child: Text(
              value,
              key: ValueKey<String>('$label$value'),
              textAlign: TextAlign.center,
              style: TextStyle(
                color: color,
                fontSize: AppDimens.fH2,
                fontWeight: FontWeight.w900,
                height: 1.0,
                fontFeatures: const [FontFeature.tabularFigures()],
              ),
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            color: UiConstants.subtitleTextColor,
            fontSize: AppDimens.fMicro,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }

  Widget _separator(Color color) {
    return Padding(
      // Nudge down so the colon centres on the digit boxes, not the labels.
      padding: const EdgeInsets.only(top: 9, left: 3, right: 3),
      child: Text(
        ':',
        style: TextStyle(
          color: color.withValues(alpha: 0.7),
          fontSize: AppDimens.fH2,
          fontWeight: FontWeight.w900,
          height: 1.0,
        ),
      ),
    );
  }
}
