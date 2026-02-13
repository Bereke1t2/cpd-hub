import 'package:flutter/material.dart';

import '../../../../core/ui_constants.dart';

class DifficultyBox extends StatelessWidget {
  final String difficulty;

  const DifficultyBox({super.key, required this.difficulty});

  @override
  Widget build(BuildContext context) {
    final lowerDiff = difficulty.toLowerCase();
    Color bgColor;
    Color textColor;

    if (lowerDiff == 'easy') {
      bgColor = Colors.green.withOpacity(0.15);
      textColor = Colors.greenAccent.shade400;
    } else if (lowerDiff == 'medium') {
      bgColor = Colors.orange.withOpacity(0.15);
      textColor = Colors.orangeAccent.shade400;
    } else {
      bgColor = Colors.red.withOpacity(0.15);
      textColor = Colors.redAccent.shade400;
    }

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 10.0),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(color: textColor.withOpacity(0.3), width: 0.5),
      ),
      child: Text(
        difficulty,
        style: TextStyle(
          color: textColor,
          fontSize: 11.0,
          fontWeight: FontWeight.w900,
          letterSpacing: 0.2,
        ),
      ),
    );
  }
}
