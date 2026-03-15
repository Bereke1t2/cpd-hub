import 'package:flutter/material.dart';
import 'package:cpd_hub/core/theme/theme_ext.dart';
import '../../../../core/ui_constants.dart';

class ProfileSection extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color? color;

  const ProfileSection({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final sc = context.sc;
    final themeColor = color ?? UiConstants.statTextColor;

    return Container(
      padding: EdgeInsets.all(12.0 * sc),
      decoration: BoxDecoration(
        color: UiConstants.infoBackgroundColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: themeColor.withValues(alpha: 0.1)),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8.0 * sc),
            decoration: BoxDecoration(
              color: themeColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              icon,
              color: themeColor,
              size: 20.0 * sc,
            ),
          ),
          SizedBox(width: 12 * sc),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 11 * sc,
                    fontWeight: FontWeight.w600,
                    color: UiConstants.subtitleTextColor.withValues(alpha: 0.7),
                    letterSpacing: 0.3,
                  ),
                ),
                SizedBox(height: 3 * sc),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 15 * sc,
                    fontWeight: FontWeight.w700,
                    color: UiConstants.mainTextColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
