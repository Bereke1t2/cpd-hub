import 'package:flutter/material.dart';
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
    final ratingColor = UiConstants.getUserRatingColor(rating);
    final isElite = rating >= 2400;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: UiConstants.infoBackgroundColor,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isElite ? ratingColor.withOpacity(0.4) : UiConstants.borderColor.withOpacity(0.3),
          width: isElite ? 1.5 : 1,
        ),
        boxShadow: [
          if (isElite)
            BoxShadow(
              color: ratingColor.withOpacity(0.1),
              blurRadius: 15,
              spreadRadius: 2,
            ),
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(24),
          onTap: onTap,
          splashColor: ratingColor.withOpacity(0.05),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                _Avatar(avatarUrl: avatarUrl, ratingColor: ratingColor, isElite: isElite),
                const SizedBox(width: 16),
                Expanded(
                  child: _UserInfo(
                    username: username,
                    bio: bio,
                    rating: rating,
                    ratingColor: ratingColor,
                  ),
                ),
                const SizedBox(width: 12),
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
    return Container(
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: ratingColor.withOpacity(0.5),
          width: isElite ? 2 : 1.5,
        ),
      ),
      child: CircleAvatar(
        radius: 28,
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          username,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: ratingColor,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 4),
        Text(
          bio,
          style: TextStyle(
            fontSize: 11,
            color: UiConstants.subtitleTextColor.withOpacity(0.7),
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
            color: ratingColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            rating.toString(),
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
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
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.emoji_events_rounded,
          size: 18,
          color: ratingColor.withOpacity(0.6),
        ),
        const SizedBox(height: 4),
        Text(
          "#$rank",
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w900,
            color: UiConstants.mainTextColor,
          ),
        ),
      ],
    );
  }
}