
import 'package:flutter/material.dart';
import 'package:cpd_hub/core/ui_constants.dart';
import 'package:cpd_hub/future/main/presentation/widget/liked_and_dis_button.dart';
import 'package:cpd_hub/future/main/presentation/widget/normal_buttons.dart';
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
  const TodaysProblemBox({super.key , required this.problemTitle , required this.solved , required this.tags , required this.liked , required this.disliked , required this.difficulty , required this.isLiked , required this.isDisliked, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            UiConstants.primaryButtonColor.withOpacity(0.15),
            UiConstants.primaryButtonColor.withOpacity(0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(28.0),
        border: Border.all(color: UiConstants.primaryButtonColor.withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
            color: UiConstants.primaryButtonColor.withOpacity(0.1),
            blurRadius: 30,
            spreadRadius: -10,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28.0),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            splashColor: UiConstants.primaryButtonColor.withOpacity(0.1),
            child: Stack(
              children: [
            Positioned(
              right: -20,
              top: -20,
              child: Icon(
                Icons.star_rounded,
                size: 150,
                color: UiConstants.primaryButtonColor.withOpacity(0.03),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: UiConstants.primaryButtonColor,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Text(
                          "DAILY TASK",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 10,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 1,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Row(
                        children: [
                          Icon(Icons.people_alt_rounded, size: 14, color: UiConstants.subtitleTextColor.withOpacity(0.6)),
                          const SizedBox(width: 4),
                          Text(
                            "${solved.toInt()} solvers",
                            style: TextStyle(
                              color: UiConstants.subtitleTextColor.withOpacity(0.6),
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16.0),
                  Hero(
                    tag: 'problem_$problemTitle',
                    child: Material(
                      color: Colors.transparent,
                      child: Text(
                        problemTitle,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w900,
                          color: UiConstants.mainTextColor,
                          letterSpacing: -0.8,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12.0),
                  Wrap(
                    spacing: 8.0,
                    runSpacing: 8.0,
                    children: tags.map((tag) => TagBox(tag: tag)).toList(),
                  ),
                  const SizedBox(height: 24.0),
                  Wrap(
                    alignment: WrapAlignment.spaceBetween,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    spacing: 12,
                    runSpacing: 12,
                    children: [
                      LikedAndDislikedButtons(
                        isLiked: isLiked,
                        isDisliked: isDisliked,
                        likedCount: liked.toInt(),
                        dislikedCount: disliked.toInt(),
                        onLike: () {},
                        onDislike: () {},
                      ),
                      ElevatedButton(
                        onPressed: onTap,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white.withOpacity(0.05),
                          foregroundColor: UiConstants.mainTextColor,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                            side: BorderSide(color: Colors.white.withOpacity(0.1)),
                          ),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              "Details",
                              style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(width: 8),
                            Icon(Icons.arrow_forward_ios_rounded, size: 10),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  ),
);
  }
}