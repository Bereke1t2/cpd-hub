import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cpd_hub/core/theme/theme_ext.dart';
import 'package:cpd_hub/core/ui_constants.dart';

class CountdownTimer extends StatefulWidget {
  final DateTime targetTime;
  final bool compact;

  const CountdownTimer({
    super.key,
    required this.targetTime,
    this.compact = false,
  });

  @override
  State<CountdownTimer> createState() => _CountdownTimerState();
}

class _CountdownTimerState extends State<CountdownTimer> {
  late Timer _timer;
  late Duration _remaining;

  @override
  void initState() {
    super.initState();
    _remaining = widget.targetTime.difference(DateTime.now());
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      final diff = widget.targetTime.difference(DateTime.now());
      if (!mounted) return;
      setState(() => _remaining = diff);
      if (diff.isNegative) _timer.cancel();
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final sc = context.sc;

    if (_remaining.isNegative) {
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 8 * sc, vertical: 4 * sc),
        decoration: BoxDecoration(
          color: Colors.redAccent.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.play_circle_filled_rounded, size: 12 * sc, color: Colors.redAccent),
            SizedBox(width: 4 * sc),
            Text(
              'LIVE NOW',
              style: TextStyle(
                color: Colors.redAccent,
                fontSize: 10 * sc,
                fontWeight: FontWeight.w800,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      );
    }

    final days = _remaining.inDays;
    final hours = _remaining.inHours % 24;
    final minutes = _remaining.inMinutes % 60;
    final seconds = _remaining.inSeconds % 60;

    if (widget.compact) {
      String text;
      if (days > 0) {
        text = '${days}d ${hours}h ${minutes}m';
      } else if (hours > 0) {
        text = '${hours}h ${minutes}m ${seconds}s';
      } else {
        text = '${minutes}m ${seconds}s';
      }

      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.timer_rounded, size: 12 * sc, color: UiConstants.primaryButtonColor),
          SizedBox(width: 4 * sc),
          Text(
            text,
            style: TextStyle(
              color: UiConstants.primaryButtonColor,
              fontSize: 11 * sc,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      );
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (days > 0) _buildUnit(days.toString().padLeft(2, '0'), 'D', sc),
        if (days > 0) _buildSeparator(sc),
        _buildUnit(hours.toString().padLeft(2, '0'), 'H', sc),
        _buildSeparator(sc),
        _buildUnit(minutes.toString().padLeft(2, '0'), 'M', sc),
        _buildSeparator(sc),
        _buildUnit(seconds.toString().padLeft(2, '0'), 'S', sc),
      ],
    );
  }

  Widget _buildUnit(String value, String label, double sc) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 6 * sc, vertical: 4 * sc),
      decoration: BoxDecoration(
        color: UiConstants.primaryButtonColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            value,
            style: TextStyle(
              color: UiConstants.primaryButtonColor,
              fontSize: 14 * sc,
              fontWeight: FontWeight.w900,
              fontFeatures: const [FontFeature.tabularFigures()],
            ),
          ),
          Text(
            label,
            style: TextStyle(
              color: UiConstants.subtitleTextColor.withValues(alpha: 0.5),
              fontSize: 8 * sc,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSeparator(double sc) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 2 * sc),
      child: Text(
        ':',
        style: TextStyle(
          color: UiConstants.primaryButtonColor.withValues(alpha: 0.5),
          fontSize: 14 * sc,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}
