import 'package:flutter/material.dart';
import 'package:cpd_hub/core/theme/theme_ext.dart';
import 'package:cpd_hub/core/ui_constants.dart';

class ProblemBox extends StatelessWidget {
  final String title;
  final String difficulty;
  final VoidCallback? onTap;
  const ProblemBox({super.key, required this.title, required this.difficulty, this.onTap});

  @override
  Widget build(BuildContext context) {
    final sc = context.sc;
    final lowerDiff = difficulty.toLowerCase();
    Color diffColor;
    if (lowerDiff == 'easy') {
      diffColor = Colors.greenAccent;
    } else if (lowerDiff == 'medium') {
      diffColor = Colors.orangeAccent;
    } else {
      diffColor = Colors.redAccent;
    }

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap ?? () {},
        splashColor: diffColor.withValues(alpha: 0.05),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 14.0 * sc, vertical: 10.0 * sc),
          child: Row(
            children: [
              Container(
                width: 3,
                height: 20 * sc,
                decoration: BoxDecoration(
                  color: diffColor.withValues(alpha: 0.6),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              SizedBox(width: 12.0 * sc),
              Expanded(
                child: Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: UiConstants.mainTextColor,
                    fontSize: 14 * sc,
                    fontWeight: FontWeight.w600,
                    letterSpacing: -0.2,
                  ),
                ),
              ),
              SizedBox(width: 10.0 * sc),
              Container(
                padding: EdgeInsets.symmetric(vertical: 4.0 * sc, horizontal: 10.0 * sc),
                decoration: BoxDecoration(
                  color: diffColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  difficulty,
                  style: TextStyle(
                    color: diffColor,
                    fontSize: 10.0 * sc,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.3,
                  ),
                ),
              ),
              SizedBox(width: 6.0 * sc),
              Icon(
                Icons.chevron_right_rounded,
                color: UiConstants.subtitleTextColor.withValues(alpha: 0.3),
                size: 16 * sc,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
