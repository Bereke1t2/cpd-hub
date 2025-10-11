import 'package:flutter/material.dart';

import '../../../../core/ui_constants.dart';

class ProfileSection extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  const ProfileSection({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          color: UiConstants.statTextColor,
          size: 50.0,
        ),
        const SizedBox(width: 4),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 14,
                color: UiConstants.subtitleTextColor,
              ),
            ),
            Text(
              subtitle,
              style: const TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: UiConstants.mainTextColor,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
