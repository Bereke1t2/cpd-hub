import 'package:flutter/material.dart';
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
    final isUpcoming = date.isAfter(DateTime.now());
    final statusColor = isUpcoming ? UiConstants.primaryButtonColor : UiConstants.subtitleTextColor.withOpacity(0.5);
    final statusText = isUpcoming ? "Upcoming" : "Finished";

    return Hero(
      tag: 'contest_${title}',
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: UiConstants.infoBackgroundColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: UiConstants.borderColor.withOpacity(0.3)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(20),
            splashColor: UiConstants.primaryButtonColor.withOpacity(0.05),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: statusColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: statusColor.withOpacity(0.2)),
                        ),
                        child: Text(
                          statusText,
                          style: TextStyle(
                            color: statusColor,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                      if (participated)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.blue.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Row(
                            children: [
                              Icon(Icons.check_circle_outline_rounded, size: 12, color: Colors.blue),
                              SizedBox(width: 4),
                              Text(
                                "Participated",
                                style: TextStyle(color: Colors.blue, fontSize: 10, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: UiConstants.mainTextColor,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      _buildStatIcon(Icons.code_rounded, "$numberOfProblems Problems"),
                      const SizedBox(width: 16),
                      _buildStatIcon(Icons.people_outline_rounded, "$numberOfContestants Contestants"),
                      const SizedBox(width: 16),
                      _buildStatIcon(Icons.access_time_rounded, isUpcoming ? "2h 30m" : "Ended"),
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

  Widget _buildStatIcon(IconData icon, String label) {
    return Row(
      children: [
        Icon(icon, size: 14, color: UiConstants.subtitleTextColor.withOpacity(0.6)),
        const SizedBox(width: 4),
        Text(
          label,
          style: TextStyle(
            color: UiConstants.subtitleTextColor.withOpacity(0.8),
            fontSize: 11,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}