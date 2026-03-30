import 'package:flutter/material.dart';
import 'package:cpd_hub/core/theme/theme_ext.dart';
import 'package:cpd_hub/future/main/presentation/widget/liked_and_dis_button.dart';
import 'package:cpd_hub/future/main/presentation/widget/tag_box.dart';

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

  @override
  Widget build(BuildContext context) {
    final sc = context.sc;
    final lowerDiff = difficulty.toLowerCase();
    Color diffColor;
    if (lowerDiff == 'easy') {
      diffColor = Colors.greenAccent;
    } else if (lowerDiff == 'medium') {
      diffColor = Colors.orangeAccent;
    } else {
      diffColor = Colors.redAccent;
    }

    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(bottom: 12.0 * sc),
      decoration: BoxDecoration(
        color: UiConstants.infoBackgroundColor.withValues(alpha: 0.85),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: diffColor.withValues(alpha: 0.12)),
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(18),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(18),
          splashColor: diffColor.withValues(alpha: 0.05),
          highlightColor: Colors.transparent,
          child: Padding(
            padding: EdgeInsets.all(14.0 * sc),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    DifficultyBox(difficulty: difficulty),
                    SizedBox(width: 10.0 * sc),
                    Expanded(
                      child: Hero(
                        tag: 'problem_$title',
                        child: Material(
                          color: Colors.transparent,
                          child: Text(
                            title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: UiConstants.mainTextColor,
                              fontSize: 15 * sc,
                              fontWeight: FontWeight.w700,
                              letterSpacing: -0.3,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 8 * sc),
                    _buildSolvedStatus(sc),
                  ],
                ),
                SizedBox(height: 10.0 * sc),
                Wrap(
                  spacing: 6.0 * sc,
                  runSpacing: 6.0 * sc,
                  children: tags.map((tag) => TagBox(tag: tag)).toList(),
                ),
                SizedBox(height: 12.0 * sc),
                Row(
                  children: [
                    Icon(Icons.history_rounded, size: 14 * sc, color: UiConstants.subtitleTextColor.withValues(alpha: 0.5)),
                    SizedBox(width: 4 * sc),
                    Text(
                      _getTimeAgo(timestamp),
                      style: TextStyle(
                        color: UiConstants.subtitleTextColor.withValues(alpha: 0.5),
                        fontSize: 12 * sc,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: () {},
                      behavior: HitTestBehavior.opaque,
                      child: LikedAndDislikedButtons(
                        isLiked: isLiked,
                        isDisliked: isDisliked,
                        likedCount: likedCount,
                        dislikedCount: dislikedCount,
                        onLike: onLike ?? () {},
                        onDislike: onDislike ?? () {},
                      ),
                    ),
                    SizedBox(width: 8.0 * sc),
                    Icon(Icons.arrow_forward_ios_rounded, color: UiConstants.primaryButtonColor.withValues(alpha: 0.5), size: 14.0 * sc),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSolvedStatus(double sc) {
    return Icon(
      isSolved ? Icons.check_circle_rounded : Icons.radio_button_unchecked_rounded,
      color: isSolved ? Colors.green.shade400 : Colors.white24,
      size: 18.0 * sc,
    );
  }

  String _getTimeAgo(DateTime dateTime) {
    final difference = DateTime.now().difference(dateTime);
    if (difference.inDays > 0) return "${difference.inDays}d ago";
    if (difference.inHours > 0) return "${difference.inHours}h ago";
    if (difference.inMinutes > 0) return "${difference.inMinutes}m ago";
    return "just now";
  }
}
