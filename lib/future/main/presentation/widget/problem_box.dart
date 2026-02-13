import 'package:flutter/material.dart';
import 'package:cpd_hub/core/ui_constants.dart';

class ProblemBox extends StatelessWidget {
  final String title;
  final String difficulty;
  final VoidCallback? onTap;
  const ProblemBox({super.key, required this.title, required this.difficulty, this.onTap});

  @override
  Widget build(BuildContext context) {
    final lowerDiff = difficulty.toLowerCase();
    Color diffColor;
    if (lowerDiff == 'easy') {
      diffColor = Colors.greenAccent;
    } else if (lowerDiff == 'medium') {
      diffColor = Colors.orangeAccent;
    } else {
      diffColor = Colors.redAccent;
    }

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12.0, left: 8.0, right: 8.0),
      decoration: BoxDecoration(
        color: UiConstants.infoBackgroundColor.withOpacity(0.8),
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(color: UiConstants.borderColor.withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16.0),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap ?? () {},
            splashColor: diffColor.withOpacity(0.05),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
              child: Row(
                children: [
                  Container(
                    width: 4,
                    height: 24,
                    decoration: BoxDecoration(
                      color: diffColor.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(width: 12.0),
                  Expanded(
                    child: Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: UiConstants.mainTextColor,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        letterSpacing: -0.2,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12.0),
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 10.0),
                    decoration: BoxDecoration(
                      color: diffColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8.0),
                      border: Border.all(color: diffColor.withOpacity(0.2)),
                    ),
                    child: Text(
                      difficulty,
                      style: TextStyle(
                        color: diffColor,
                        fontSize: 10.0,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8.0),
                  Icon(
                    Icons.chevron_right_rounded,
                    color: UiConstants.subtitleTextColor.withOpacity(0.3),
                    size: 18,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
