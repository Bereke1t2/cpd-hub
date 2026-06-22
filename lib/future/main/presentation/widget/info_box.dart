import 'package:flutter/material.dart';
import 'package:lab_portal/core/theme/app_dimens.dart';
import 'package:lab_portal/core/ui_constants.dart';
import 'package:lab_portal/core/widgets/app_card.dart';
import 'package:lab_portal/core/widgets/app_text.dart';

class InfoBox extends StatelessWidget {
  final String title;
  final String description;
  const InfoBox({super.key, required this.title, required this.description});

  IconData _iconForTitle(String t) {
    final l = t.toLowerCase();
    if (l.contains('contest')) return Icons.emoji_events_outlined;
    if (l.contains('problem')) return Icons.bolt_outlined;
    return Icons.info_outline;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
          bottom: AppDimens.md, left: AppDimens.md, right: AppDimens.md),
      child: AppCard(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(AppDimens.sm),
              decoration: BoxDecoration(
                color: UiConstants.primaryButtonColor.withValues(alpha: 0.12),
                borderRadius: AppDimens.brSm,
              ),
              child: Icon(
                _iconForTitle(title),
                color: UiConstants.primaryButtonColor,
                size: AppDimens.iconMd,
              ),
            ),
            const SizedBox(width: AppDimens.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText.title(title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      color: UiConstants.problemTextColor),
                  const SizedBox(height: AppDimens.sm),
                  AppText.body(description,
                      color: UiConstants.subtitleTextColor),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
