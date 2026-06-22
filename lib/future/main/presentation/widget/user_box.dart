import 'package:flutter/material.dart';
import 'package:lab_portal/core/theme/app_colors.dart';
import 'package:lab_portal/core/theme/app_dimens.dart';
import 'package:lab_portal/core/ui_constants.dart';
import 'package:lab_portal/core/widgets/app_card.dart';
import 'package:lab_portal/core/widgets/app_chip.dart';
import 'package:lab_portal/core/widgets/app_text.dart';
import 'package:lab_portal/core/widgets/avatar.dart';

class UserBox extends StatelessWidget {
  final String username;
  final String bio;
  final String avatarUrl;
  final int rating;
  final int rank;
  final VoidCallback? onTap;

  const UserBox({
    super.key,
    required this.username,
    required this.bio,
    required this.avatarUrl,
    required this.rating,
    required this.rank,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final ratingColor = AppColors.rating(rating);
    final initials = username.length >= 2
        ? username.substring(0, 2).toUpperCase()
        : username.toUpperCase();

    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: AppDimens.md, vertical: AppDimens.sm),
      child: AppCard(
        accent: ratingColor,
        onTap: onTap,
        child: Row(
          children: [
            Avatar(
              initials: initials,
              imageUrl: avatarUrl,
              color: ratingColor,
              size: AppDimens.avatarLg,
            ),
            const SizedBox(width: AppDimens.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: AppText.title(
                          username,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          color: ratingColor,
                        ),
                      ),
                      const SizedBox(width: AppDimens.sm),
                      AppChip(rating.toString(), color: ratingColor),
                      const SizedBox(width: AppDimens.xs),
                      AppChip('Rank $rank',
                          color: UiConstants.subtitleTextColor),
                    ],
                  ),
                  const SizedBox(height: AppDimens.xs),
                  AppText.caption(bio,
                      maxLines: 2, overflow: TextOverflow.ellipsis),
                ],
              ),
            ),
            const SizedBox(width: AppDimens.sm),
            Icon(Icons.chevron_right,
                color: UiConstants.subtitleTextColor, size: AppDimens.iconMd),
          ],
        ),
      ),
    );
  }
}
