import 'package:flutter/material.dart';

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
    return Row(
      children: [
        Row(
          children: [
            IconButton(
              icon: Icon(isLiked ? Icons.thumb_up : Icons.thumb_up_outlined, color: isLiked ? Colors.green : Colors.grey),
              onPressed: onLike,
            ),
            Text(likedCount.toString() , style: TextStyle(color: Colors.white),),
          ],
        ),
        SizedBox(width: 8.0),
        Row(
          children: [
            IconButton(
              icon: Icon(isDisliked ? Icons.thumb_down : Icons.thumb_down_outlined, color: isDisliked ? Colors.red : Colors.grey),
              onPressed: onDislike,
            ),
            Text(dislikedCount.toString() , style: TextStyle(color: Colors.white),),
          ],
        ),
      ],
    );
  }
}