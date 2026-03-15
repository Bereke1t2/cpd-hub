import 'package:flutter/material.dart';
import 'package:cpd_hub/core/theme/theme_ext.dart';
import '../../../../core/ui_constants.dart';

class ContestBox extends StatelessWidget {
  final String title;
  final bool participated;
  final DateTime date;
  final int numberOfProblems;
  final DateTime time;
  final int numberOfContestants;
  final VoidCallback? onTap;

  const ContestBox({
    super.key,
    required this.title,
    required this.participated,
    required this.date,
    required this.numberOfProblems,
    required this.time,
    required this.numberOfContestants,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final sc = context.sc;
    final isUpcoming = date.isAfter(DateTime.now());
    final statusColor = isUpcoming ? UiConstants.primaryButtonColor : UiConstants.subtitleTextColor.withValues(alpha: 0.5);
    final statusText = isUpcoming ? "Upcoming" : "Finished";

    return Hero(
      tag: 'contest_$title',
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 16 * sc, vertical: 6 * sc),
        decoration: BoxDecoration(
          color: UiConstants.infoBackgroundColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: UiConstants.borderColor.withValues(alpha: 0.15)),
        ),
        child: Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(16),
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(16),
            splashColor: UiConstants.primaryButtonColor.withValues(alpha: 0.05),
            child: Padding(
              padding: EdgeInsets.all(14 * sc),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 10 * sc, vertical: 4 * sc),
                        decoration: BoxDecoration(
                          color: statusColor.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          statusText,
                          style: TextStyle(
                            color: statusColor,
                            fontSize: 11 * sc,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.3,
                          ),
                        ),
                      ),
                      if (participated)
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.check_circle_rounded, size: 14 * sc, color: Colors.blue),
                            SizedBox(width: 4 * sc),
                            Text(
                              "Participated",
                              style: TextStyle(color: Colors.blue, fontSize: 11 * sc, fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                    ],
                  ),
                  SizedBox(height: 12 * sc),
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 15 * sc,
                      fontWeight: FontWeight.w700,
                      color: UiConstants.mainTextColor,
                      letterSpacing: -0.3,
                    ),
                  ),
                  SizedBox(height: 10 * sc),
                  Row(
                    children: [
                      _buildStatIcon(Icons.code_rounded, "$numberOfProblems Problems", sc),
                      SizedBox(width: 16 * sc),
                      _buildStatIcon(Icons.people_outline_rounded, "$numberOfContestants Users", sc),
                      SizedBox(width: 16 * sc),
                      _buildStatIcon(Icons.access_time_rounded, isUpcoming ? "2h 30m" : "Ended", sc),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatIcon(IconData icon, String label, double sc) {
    return Row(
      children: [
        Icon(icon, size: 13 * sc, color: UiConstants.subtitleTextColor.withValues(alpha: 0.6)),
        SizedBox(width: 5 * sc),
        Text(
          label,
          style: TextStyle(
            color: UiConstants.subtitleTextColor.withValues(alpha: 0.8),
            fontSize: 11 * sc,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
