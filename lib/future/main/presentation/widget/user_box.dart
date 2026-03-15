import 'package:flutter/material.dart';
import 'package:cpd_hub/core/theme/theme_ext.dart';
import '../../../../core/ui_constants.dart';

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
    final sc = context.sc;
    final ratingColor = UiConstants.getUserRatingColor(rating);
    final isElite = rating >= 2400;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16 * sc, vertical: 6 * sc),
      decoration: BoxDecoration(
        color: UiConstants.infoBackgroundColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isElite ? ratingColor.withValues(alpha: 0.3) : UiConstants.borderColor.withValues(alpha: 0.15),
        ),
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          splashColor: ratingColor.withValues(alpha: 0.05),
          child: Padding(
            padding: EdgeInsets.all(12 * sc),
            child: Row(
              children: [
                _Avatar(avatarUrl: avatarUrl, ratingColor: ratingColor, isElite: isElite),
                SizedBox(width: 12 * sc),
                Expanded(
                  child: _UserInfo(
                    username: username,
                    bio: bio,
                    rating: rating,
                    ratingColor: ratingColor,
                  ),
                ),
                SizedBox(width: 8 * sc),
                _RankBadge(rank: rank, ratingColor: ratingColor),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Avatar extends StatelessWidget {
  final String avatarUrl;
  final Color ratingColor;
  final bool isElite;
  const _Avatar({required this.avatarUrl, required this.ratingColor, required this.isElite});

  @override
  Widget build(BuildContext context) {
    final sc = context.sc;
    return Container(
      padding: EdgeInsets.all(2 * sc),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: ratingColor.withValues(alpha: 0.5),
          width: isElite ? 1.5 : 1,
        ),
      ),
      child: CircleAvatar(
        radius: 20 * sc,
        backgroundColor: UiConstants.backgroundColor,
        backgroundImage: NetworkImage(avatarUrl),
      ),
    );
  }
}

class _UserInfo extends StatelessWidget {
  final String username;
  final String bio;
  final int rating;
  final Color ratingColor;

  const _UserInfo({
    required this.username,
    required this.bio,
    required this.rating,
    required this.ratingColor,
  });

  @override
  Widget build(BuildContext context) {
    final sc = context.sc;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          username,
          style: TextStyle(
            fontSize: 14 * sc,
            fontWeight: FontWeight.w700,
            color: ratingColor,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        SizedBox(height: 3 * sc),
        Text(
          bio,
          style: TextStyle(
            fontSize: 11 * sc,
            color: UiConstants.subtitleTextColor.withValues(alpha: 0.6),
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        SizedBox(height: 5 * sc),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 8 * sc, vertical: 3 * sc),
          decoration: BoxDecoration(
            color: ratingColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            rating.toString(),
            style: TextStyle(
              fontSize: 11 * sc,
              fontWeight: FontWeight.w700,
              color: ratingColor,
            ),
          ),
        ),
      ],
    );
  }
}

class _RankBadge extends StatelessWidget {
  final int rank;
  final Color ratingColor;
  const _RankBadge({required this.rank, required this.ratingColor});

  @override
  Widget build(BuildContext context) {
    final sc = context.sc;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.emoji_events_rounded,
          size: 18 * sc,
          color: ratingColor.withValues(alpha: 0.6),
        ),
        SizedBox(height: 4 * sc),
        Text(
          "#$rank",
          style: TextStyle(
            fontSize: 12 * sc,
            fontWeight: FontWeight.w900,
            color: UiConstants.mainTextColor,
          ),
        ),
      ],
    );
  }
}
