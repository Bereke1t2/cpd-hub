import 'package:flutter/material.dart';
import 'package:cpd_hub/core/ui_constants.dart';

class InfoBox extends StatelessWidget {
  final String title;
  final String description;
  const InfoBox({super.key, required this.title, required this.description  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 16.0, left: 16.0, right: 16.0),
      decoration: BoxDecoration(
        color: UiConstants.infoBackgroundColor.withOpacity(0.6),
        borderRadius: BorderRadius.circular(20.0),
        border: Border.all(color: UiConstants.borderColor.withOpacity(0.15)),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20.0),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {},
            splashColor: UiConstants.primaryButtonColor.withOpacity(0.05),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: UiConstants.primaryButtonColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      _getIconForTitle(title),
                      color: UiConstants.primaryButtonColor,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 16.0),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: const TextStyle(
                            color: UiConstants.mainTextColor,
                            fontSize: 17,
                            fontWeight: FontWeight.w900,
                            letterSpacing: -0.5,
                          ),
                        ),
                        const SizedBox(height: 6.0),
                        Text(
                          description,
                          style: TextStyle(
                            color: UiConstants.subtitleTextColor.withOpacity(0.7),
                            fontSize: 13,
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