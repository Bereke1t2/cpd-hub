import 'package:flutter/material.dart';
import 'package:lab_portal/core/ui_constants.dart';

class ContestBox extends StatelessWidget {
  final String title;
  final bool participated;
  final DateTime date;
  final int numberOfProblems;
  final DateTime time;
  final int numberOfContestants;
  const ContestBox({
    super.key,
    required this.title,
    required this.participated,
    required this.date,
    required this.numberOfProblems,
    required this.time,
    required this.numberOfContestants,
  });

  String _relativeFrom(DateTime date) {
    final diff = DateTime.now().difference(date);
    if (diff.inDays > 0) return '${diff.inDays}d ago';
    if (diff.inHours > 0) return '${diff.inHours}h ago';
    if (diff.inMinutes > 0) return '${diff.inMinutes}m ago';
    return 'just now';
  }

  @override
  Widget build(BuildContext context) {
    final titleStyle = const TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.bold,
      color: UiConstants.mainTextColor,
    );

    final metaStyle = const TextStyle(
      color: UiConstants.subtitleTextColor,
      fontSize: 12,
    );

    return Container(
      padding: const EdgeInsets.all(16.0),
      margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 16.0),
      decoration: BoxDecoration(
        color: UiConstants.infoBackgroundColor,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: titleStyle,
                ),
              ),
              const SizedBox(width: 8),
              Icon(
                participated ? Icons.check_circle : Icons.radio_button_unchecked,
                color: participated
                    ? Colors.green.shade400
                    : UiConstants.subtitleTextColor,
                size: 20.0,
              ),
            ],
          ),
          const SizedBox(height: 10.0),
          Wrap(
            spacing: 12,
            runSpacing: 6,
            children: [
              Text('$numberOfProblems problems', style: metaStyle),
              Text(_relativeFrom(date), style: metaStyle),
              Text('$numberOfContestants contestants', style: metaStyle),
            ],
          ),
        ],
      ),
    );
  }
}