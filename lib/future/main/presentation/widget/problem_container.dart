import 'package:flutter/material.dart';
import 'package:lab_portal/future/main/presentation/widget/liked_and_dis_button.dart';
import 'package:lab_portal/future/main/presentation/widget/tag_box.dart';

import '../../../../core/ui_constants.dart';
import 'difficulty_box.dart';

class ProblemContainer extends StatelessWidget {
  final String title;
  final String difficulty;
  final bool isSolved;
  final int likedCount;
  final int dislikedCount;
  final VoidCallback? onLike;
  final VoidCallback? onDislike;
  final VoidCallback? onTap;
  final DateTime timestamp;
  final List<String> tags;
  final bool isLiked;
  final bool isDisliked;

  const ProblemContainer({
    super.key,
    required this.title,
    required this.difficulty,
    this.isSolved = false,
    this.likedCount = 0,
    this.dislikedCount = 0,
    this.onLike,
    this.onDislike,
    this.onTap,
    required this.timestamp,
    required this.tags,
    this.isLiked = false,
    this.isDisliked = false,
  });

  String _relativeFrom(DateTime date) {
    final diff = DateTime.now().difference(date);
    if (diff.inDays > 0) return '${diff.inDays}d ago';
    if (diff.inHours > 0) return '${diff.inHours}h ago';
    if (diff.inMinutes > 0) return '${diff.inMinutes}m ago';
    return 'just now';
  }

  @override
  Widget build(BuildContext context) {
    final container = Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16.0),
      margin: const EdgeInsets.only(bottom: 10.0, left: 5.0, right: 5.0),
      decoration: BoxDecoration(
        color: UiConstants.infoBackgroundColor,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DifficultyBox(difficulty: difficulty),
              const SizedBox(width: 8.0),
              Expanded(
                child: Text(
                  title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: UiConstants.mainTextColor,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 8.0),
              Icon(
                isSolved ? Icons.check_circle : Icons.radio_button_unchecked,
                color: isSolved ? Colors.green.shade400 : Colors.grey.shade400,
                size: 20.0,
              ),
            ],
          ),
          const SizedBox(height: 8.0),
          Wrap(
            spacing: 6.0,
            runSpacing: 6.0,
            children: List.generate(tags.length, (index) {
              final tag = tags[index];
              return TagBox(tag: tag);
            }),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: Text(
                  _relativeFrom(timestamp),
                  style: const TextStyle(
                    color: UiConstants.subtitleTextColor,
                    fontSize: 12,
                  ),
                ),
              ),
              LikedAndDislikedButtons(
                isLiked: isLiked,
                isDisliked: isDisliked,
                likedCount: likedCount,
                dislikedCount: dislikedCount,
                onLike: onLike ?? () {},
                onDislike: onDislike ?? () {},
              ),
              const SizedBox(width: 8.0),
              Icon(
                Icons.link,
                color: UiConstants.subtitleTextColor,
                size: 16.0,
              ),
            ],
          ),
        ],
      ),
    );

    if (onTap == null) return container;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8.0),
      child: container,
    );
  }
}