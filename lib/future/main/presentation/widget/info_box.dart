import 'package:flutter/material.dart';
import 'package:cpd_hub/core/theme/theme_ext.dart';
import 'package:cpd_hub/core/ui_constants.dart';

class InfoBox extends StatelessWidget {
  final String title;
  final String description;
  const InfoBox({super.key, required this.title, required this.description});

  @override
  Widget build(BuildContext context) {
    final sc = context.sc;
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(bottom: 10.0 * sc, left: 16.0 * sc, right: 16.0 * sc),
      decoration: BoxDecoration(
        color: UiConstants.infoBackgroundColor.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: UiConstants.borderColor.withValues(alpha: 0.1)),
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          onTap: () {},
          borderRadius: BorderRadius.circular(16),
          splashColor: UiConstants.primaryButtonColor.withValues(alpha: 0.05),
          child: Padding(
            padding: EdgeInsets.all(14.0 * sc),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.all(8 * sc),
                  decoration: BoxDecoration(
                    color: UiConstants.primaryButtonColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    _getIconForTitle(title),
                    color: UiConstants.primaryButtonColor,
                    size: 18 * sc,
                  ),
                ),
                SizedBox(width: 12.0 * sc),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          color: UiConstants.mainTextColor,
                          fontSize: 14 * sc,
                          fontWeight: FontWeight.w700,
                          letterSpacing: -0.3,
                        ),
                      ),
                      SizedBox(height: 3.0 * sc),
                      Text(
                        description,
                        style: TextStyle(
                          color: UiConstants.subtitleTextColor.withValues(alpha: 0.6),
                          fontSize: 12 * sc,
                          height: 1.4,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  IconData _getIconForTitle(String title) {
    final t = title.toLowerCase();
    if (t.contains('contest')) return Icons.emoji_events_rounded;
    if (t.contains('problem')) return Icons.code_rounded;
    if (t.contains('news')) return Icons.newspaper_rounded;
    return Icons.info_outline_rounded;
  }
}
