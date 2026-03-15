import 'package:flutter/material.dart';
import 'package:cpd_hub/core/theme/theme_ext.dart';

class DifficultyBox extends StatelessWidget {
  final String difficulty;

  const DifficultyBox({super.key, required this.difficulty});

  @override
  Widget build(BuildContext context) {
    final sc = context.sc;
    final lowerDiff = difficulty.toLowerCase();
    Color bgColor;
    Color textColor;

    if (lowerDiff == 'easy') {
      bgColor = Colors.green.withValues(alpha: 0.15);
      textColor = Colors.greenAccent.shade400;
    } else if (lowerDiff == 'medium') {
      bgColor = Colors.orange.withValues(alpha: 0.15);
      textColor = Colors.orangeAccent.shade400;
    } else {
      bgColor = Colors.red.withValues(alpha: 0.15);
      textColor = Colors.redAccent.shade400;
    }

    return Container(
      padding: EdgeInsets.symmetric(vertical: 4.0 * sc, horizontal: 10.0 * sc),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        difficulty,
        style: TextStyle(
          color: textColor,
          fontSize: 11.0 * sc,
          fontWeight: FontWeight.w800,
          letterSpacing: 0.2,
        ),
      ),
    );
  }
}
