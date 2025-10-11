import 'package:flutter/material.dart';

import '../../../../core/ui_constants.dart';

class DifficultyBox extends StatelessWidget {
  final String difficulty;

  const DifficultyBox({super.key, required this.difficulty});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
      decoration: BoxDecoration(
        color: difficulty.toLowerCase() == 'easy'
            ? UiConstants.easyProblemColor
            : difficulty.toLowerCase() == 'medium'
            ? UiConstants.mediumProblemColor
            : UiConstants.hardProblemColor,
        borderRadius: BorderRadius.circular(4.0),
      ),
      child: Text(
        difficulty,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: difficulty.toLowerCase() == 'easy'
              ? Colors.green.shade400
              : difficulty.toLowerCase() == 'medium'
              ? Colors.orange.shade400
              : Colors.red.shade400,
          fontSize: 12.0,
        ),
      ),
    );
  }
}
