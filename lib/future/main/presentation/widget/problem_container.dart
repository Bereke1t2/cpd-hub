import 'package:flutter/material.dart';
import 'package:cpd_hub/future/main/presentation/widget/liked_and_dis_button.dart';
import 'package:cpd_hub/future/main/presentation/widget/tag_box.dart';

import '../../../../core/ui_constants.dart';
import 'difficulty_box.dart';

class ProblemContainer extends StatelessWidget {
  final String title;
  final String difficulty;
  final bool isSolved ;
  final int likedCount ;
  final int dislikedCount;
  final VoidCallback? onLike ;
  final VoidCallback? onDislike ;
  final VoidCallback? onTap ;
  final DateTime timestamp ;
  final List<String> tags;
  final bool isLiked;
  final bool isDisliked;


  const ProblemContainer({super.key, required this.title, required this.difficulty, this.isSolved = false, this.likedCount = 0, this.dislikedCount = 0, this.onLike, this.onDislike, this.onTap, required this.timestamp, required this.tags, this.isLiked = false, this.isDisliked = false});

  @override
  Widget build(BuildContext context) {
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
      margin: const EdgeInsets.only(bottom: 16.0, left: 8.0, right: 8.0),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            UiConstants.infoBackgroundColor.withOpacity(0.9),
            UiConstants.infoBackgroundColor.withOpacity(0.7),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24.0),
        border: Border.all(color: UiConstants.borderColor.withOpacity(0.15)),
        boxShadow: [
          BoxShadow(
            color: diffColor.withOpacity(0.04),
            blurRadius: 20,
            spreadRadius: -5,
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24.0),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            splashColor: diffColor.withOpacity(0.05),
            highlightColor: Colors.transparent,
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            DifficultyBox(difficulty: difficulty),
                            const SizedBox(width: 14.0),
                            Expanded(
                              child: Hero(
                                tag: 'problem_$title',
                                child: Material(
                                  color: Colors.transparent,
                                  child: Text(
                                    title,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      color: UiConstants.mainTextColor,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w900,
                                      letterSpacing: -0.5,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      _buildSolvedStatus(),
                    ],
                  ),
                  const SizedBox(height: 16.0),
                  Wrap(
                    spacing: 8.0,
                    runSpacing: 8.0,
                    children: tags.map((tag) => TagBox(tag: tag)).toList(),
                  ),
                  const SizedBox(height: 20.0),
                  Wrap(
                    alignment: WrapAlignment.spaceBetween,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    spacing: 12,
                    runSpacing: 12,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.03),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.history_rounded, size: 14, color: UiConstants.subtitleTextColor.withOpacity(0.5)),
                            const SizedBox(width: 6),
                            Text(
                              _getTimeAgo(timestamp),
                              style: TextStyle(
                                color: UiConstants.subtitleTextColor.withOpacity(0.5),
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.2,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          LikedAndDislikedButtons(
                            isLiked: isLiked,
                            isDisliked: isDisliked,
                            likedCount: likedCount,
                            dislikedCount: dislikedCount,
                            onLike: onLike ?? () {},
                            onDislike: onDislike ?? () {},
                          ),
                          const SizedBox(width: 12.0),
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: UiConstants.primaryButtonColor.withOpacity(0.1),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.arrow_forward_ios_rounded, color: UiConstants.primaryButtonColor, size: 14.0),
                          ),
                        ],
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSolvedStatus() {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: isSolved ? Colors.green.withOpacity(0.12) : Colors.white.withOpacity(0.05),
        shape: BoxShape.circle,
      ),
      child: Icon(
        isSolved ? Icons.check_circle_rounded : Icons.radio_button_unchecked_rounded,
        color: isSolved ? Colors.green.shade400 : Colors.white24,
        size: 20.0,
      ),
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