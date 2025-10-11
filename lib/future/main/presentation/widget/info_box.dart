import 'package:flutter/material.dart';
import 'package:lab_portal/core/ui_constants.dart';

class InfoBox extends StatelessWidget {
  final String title;
  final String description;
  const InfoBox({super.key, required this.title, required this.description  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16.0),
      margin: const EdgeInsets.only(bottom: 16.0 , left: 16.0 , right: 16.0),
      decoration: BoxDecoration(
        color: UiConstants.infoBackgroundColor,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            softWrap: true,
            style: const TextStyle(
              color: UiConstants.problemTextColor,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8.0),
          Text(
            description,
            softWrap: true,
            // overflow: TextOverflow.visible, // (optional)
            // textAlign: TextAlign.start,     // (optional)
            style: const TextStyle(
              color: UiConstants.subtitleTextColor,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}