import 'package:flutter/material.dart';
import 'package:lab_portal/core/ui_constants.dart';

class ProblemBox extends StatelessWidget {
  final String title;
  final String difficulty;
  const ProblemBox({super.key, required this.title, required this.difficulty});

  @override
  Widget build(BuildContext context) {
    final diff = difficulty.toLowerCase();
    final bg = diff == 'easy'
        ? UiConstants.easyProblemColor
        : diff == 'medium'
            ? UiConstants.mediumProblemColor
            : UiConstants.hardProblemColor;
    final fg = diff == 'easy'
        ? Colors.green.shade400
        : diff == 'medium'
            ? Colors.orange.shade400
            : Colors.red.shade400;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14.0),
      margin: const EdgeInsets.only(bottom: 10.0, left: 12.0, right: 12.0),
      decoration: BoxDecoration(
        color: UiConstants.infoBackgroundColor,
        borderRadius: BorderRadius.circular(14.0),
        border: Border.all(
          color: UiConstants.primaryButtonColor.withOpacity(0.12),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: UiConstants.problemTextColor,
                fontSize: 14.5,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 10.0),
            decoration: BoxDecoration(
              color: bg,
              borderRadius: BorderRadius.circular(999),
              border: Border.all(color: fg.withOpacity(0.35)),
            ),
            child: Text(
              difficulty,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: fg,
                fontSize: 12.0,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
