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
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          color: UiConstants.statTextColor,
          size: 34.0,
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 13,
                  color: UiConstants.subtitleTextColor,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: UiConstants.mainTextColor,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
