import 'package:flutter/material.dart';
import 'package:lab_portal/core/ui_constants.dart';

class ProblemBox extends StatelessWidget {
  final String title;
  final String difficulty;
  const ProblemBox({super.key, required this.title, required this.difficulty});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16.0),
      margin: const EdgeInsets.only(bottom: 10.0, left: 5.0, right: 5.0),
      decoration: BoxDecoration(
        color: UiConstants.infoBackgroundColor,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title.length > 30 ? '${title.substring(0, 30)}...' : title,
            softWrap: true,
            style: const TextStyle(
              color: UiConstants.problemTextColor,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8.0),
          Container(
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
          ),
        ],
      ),
    );
  }
}
