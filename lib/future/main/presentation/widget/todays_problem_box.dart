import 'package:flutter/material.dart';
import 'package:cpd_hub/core/theme/theme_ext.dart';
import 'package:cpd_hub/core/ui_constants.dart';
import 'package:cpd_hub/future/main/presentation/widget/liked_and_dis_button.dart';

import 'package:cpd_hub/future/main/presentation/widget/tag_box.dart';

class TodaysProblemBox extends StatelessWidget {
  final bool isLiked;
  final bool isDisliked;
  final String problemTitle;
  final double solved;
  final List<String> tags;
  final double liked;
  final double disliked;
  final String difficulty;
  final VoidCallback? onTap;
  const TodaysProblemBox({
    super.key,
    required this.problemTitle,
    required this.solved,
    required this.tags,
    required this.liked,
    required this.disliked,
    required this.difficulty,
    required this.isLiked,
    required this.isDisliked,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final sc = context.sc;
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 16.0 * sc, vertical: 4.0 * sc),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            UiConstants.primaryButtonColor.withValues(alpha: 0.12),
            UiConstants.primaryButtonColor.withValues(alpha: 0.04),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: UiConstants.primaryButtonColor.withValues(alpha: 0.15)),
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          splashColor: UiConstants.primaryButtonColor.withValues(alpha: 0.08),
          child: Padding(
            padding: EdgeInsets.all(16.0 * sc),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 10 * sc, vertical: 4 * sc),
                      decoration: BoxDecoration(
                        color: UiConstants.primaryButtonColor,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        "DAILY",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 10 * sc,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.8,
                        ),
                      ),
                    ),
                    SizedBox(width: 12 * sc),
                    Icon(Icons.people_alt_rounded, size: 14 * sc, color: UiConstants.subtitleTextColor.withValues(alpha: 0.5)),
                    SizedBox(width: 4 * sc),
                    Text(
                      "${solved.toInt()} solvers",
                      style: TextStyle(
                        color: UiConstants.subtitleTextColor.withValues(alpha: 0.5),
                        fontSize: 11 * sc,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12.0 * sc),
                Hero(
                  tag: 'problem_$problemTitle',
                  child: Material(
                    color: Colors.transparent,
                    child: Text(
                      problemTitle,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 16 * sc,
                        fontWeight: FontWeight.w800,
                        color: UiConstants.mainTextColor,
                        letterSpacing: -0.5,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10.0 * sc),
                Wrap(
                  spacing: 6.0 * sc,
                  runSpacing: 6.0 * sc,
                  children: tags.map((tag) => TagBox(tag: tag)).toList(),
                ),
                SizedBox(height: 16.0 * sc),
                Row(
                  children: [
                    LikedAndDislikedButtons(
                      isLiked: isLiked,
                      isDisliked: isDisliked,
                      likedCount: liked.toInt(),
                      dislikedCount: disliked.toInt(),
                      onLike: () {},
                      onDislike: () {},
                    ),
                    const Spacer(),
                    TextButton(
                      onPressed: onTap,
                      style: TextButton.styleFrom(
                        foregroundColor: UiConstants.primaryButtonColor,
                        padding: EdgeInsets.symmetric(horizontal: 16 * sc, vertical: 10 * sc),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: BorderSide(color: UiConstants.primaryButtonColor.withValues(alpha: 0.2)),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "Solve",
                            style: TextStyle(fontSize: 12 * sc, fontWeight: FontWeight.w700),
                          ),
                          SizedBox(width: 6 * sc),
                          Icon(Icons.arrow_forward_ios_rounded, size: 12 * sc),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
