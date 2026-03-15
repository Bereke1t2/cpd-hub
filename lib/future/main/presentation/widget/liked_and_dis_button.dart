import 'package:flutter/material.dart';
import 'package:cpd_hub/core/theme/theme_ext.dart';

class LikedAndDislikedButtons extends StatelessWidget {
  final int likedCount;
  final int dislikedCount;
  final VoidCallback onLike;
  final VoidCallback onDislike;
  final bool isLiked;
  final bool isDisliked;
  const LikedAndDislikedButtons({
    super.key,
    required this.likedCount,
    required this.dislikedCount,
    required this.onLike,
    required this.onDislike,
    required this.isLiked,
    required this.isDisliked,
  });

  @override
  Widget build(BuildContext context) {
    final sc = context.sc;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: onLike,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(isLiked ? Icons.thumb_up : Icons.thumb_up_outlined, color: isLiked ? Colors.green : Colors.grey, size: 16 * sc),
              SizedBox(width: 4 * sc),
              Text(likedCount.toString(), style: TextStyle(color: Colors.white70, fontSize: 13 * sc, fontWeight: FontWeight.w500)),
            ],
          ),
        ),
        SizedBox(width: 14.0 * sc),
        GestureDetector(
          onTap: onDislike,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(isDisliked ? Icons.thumb_down : Icons.thumb_down_outlined, color: isDisliked ? Colors.red : Colors.grey, size: 16 * sc),
              SizedBox(width: 4 * sc),
              Text(dislikedCount.toString(), style: TextStyle(color: Colors.white70, fontSize: 13 * sc, fontWeight: FontWeight.w500)),
            ],
          ),
        ),
      ],
    );
  }
}
