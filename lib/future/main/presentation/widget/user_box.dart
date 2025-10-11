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
    final bg = UiConstants.infoBackgroundColor; // Base neutral background
    final subtleBlend = Color.alphaBlend(ratingColor.withOpacity(0.05), bg);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),

      curve: Curves.easeOutCubic,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            ratingColor,
            ratingColor,
            subtleBlend,
            bg,
          ],
          // Very slim colored stripe on the left
          stops: const [0.0, 0.012, 0.035, 1.0],
        ),
        boxShadow: [
            BoxShadow(
              color: ratingColor.withOpacity(0.18),
              blurRadius: 14,
              spreadRadius: 0,
              offset: const Offset(0, 4),
            ),
            BoxShadow(
              color: ratingColor.withOpacity(0.08),
              blurRadius: 4,
              offset: const Offset(0, 1),
            ),
        ],
        border: Border.all(
          color: ratingColor.withOpacity(0.20),
          width: 1,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
            onTap: onTap,
          splashColor: ratingColor.withOpacity(0.12),
          highlightColor: ratingColor.withOpacity(0.06),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
            child: Row(
              children: [
                _Avatar(avatarUrl: avatarUrl, ratingColor: ratingColor),
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
                Icon(Icons.chevron_right, color: UiConstants.subtitleTextColor),
                const SizedBox(width: 12),
                Text('Rank: $rank', style: TextStyle(color: UiConstants.subtitleTextColor)),
                
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
  const _Avatar({required this.avatarUrl, required this.ratingColor});

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 30,
      backgroundColor: ratingColor.withOpacity(0.15),
      foregroundImage: NetworkImage(avatarUrl),
      child: Icon(Icons.person, color: ratingColor.withOpacity(0.65)),
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
    final subtitleColor = UiConstants.subtitleTextColor;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Flexible(
              child: Text(
                username,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.2,
                  color: ratingColor,
                ),
              ),
            ),
            const SizedBox(width: 8),
            _RatingPill(rating: rating, ratingColor: ratingColor),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          bio,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: 13.5,
            height: 1.25,
            color: subtitleColor,
          ),
        ),
      ],
    );
  }
}

class _RatingPill extends StatelessWidget {
  final int rating;
  final Color ratingColor;
  const _RatingPill({required this.rating, required this.ratingColor});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: ratingColor.withOpacity(0.12),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: ratingColor.withOpacity(0.40), width: 1),
      ),
      child: Text(
        rating.toString(),
        style: TextStyle(
          fontSize: 12.5,
          fontWeight: FontWeight.w600,
          color: ratingColor,
          letterSpacing: 0.3,
        ),
      ),
    );
  }
}