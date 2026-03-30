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
        _buildButton(
          icon: isLiked ? Icons.thumb_up : Icons.thumb_up_outlined,
          color: isLiked ? Colors.green : Colors.grey,
          count: likedCount,
          onTap: onLike,
          sc: sc,
        ),
        SizedBox(width: 6.0 * sc),
        _buildButton(
          icon: isDisliked ? Icons.thumb_down : Icons.thumb_down_outlined,
          color: isDisliked ? Colors.red : Colors.grey,
          count: dislikedCount,
          onTap: onDislike,
          sc: sc,
        ),
      ],
    );
  }

  Widget _buildButton({
    required IconData icon,
    required Color color,
    required int count,
    required VoidCallback onTap,
    required double sc,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 8 * sc, vertical: 6 * sc),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: color, size: 16 * sc),
              SizedBox(width: 4 * sc),
              Text(
                count.toString(),
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 13 * sc,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
