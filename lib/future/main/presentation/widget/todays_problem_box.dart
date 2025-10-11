
import 'package:flutter/material.dart';
import 'package:lab_portal/core/ui_constants.dart';
import 'package:lab_portal/future/main/presentation/widget/liked_and_dis_button.dart';
import 'package:lab_portal/future/main/presentation/widget/normal_buttons.dart';
import 'package:lab_portal/future/main/presentation/widget/tag_box.dart';

class TodaysProblemBox extends StatelessWidget {
  final bool isLiked;
  final bool isDisliked;
  final String problemTitle;
  final double solved;
  final List<String> tags;
  final double liked;
  final double disliked;
  final String difficulty;
  const TodaysProblemBox({super.key , required this.problemTitle , required this.solved , required this.tags , required this.liked , required this.disliked , required this.difficulty , required this.isLiked , required this.isDisliked});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16.0),
      margin: const EdgeInsets.only(bottom: 16.0 , left: 16.0 , right: 16.0),
      decoration: BoxDecoration(
        color: UiConstants.infoBackgroundColor,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Today's Daily Problem" , style: TextStyle(fontSize: 18 , fontWeight: FontWeight.bold , color: UiConstants.mainTextColor),),
          SizedBox(height: 12.0),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(problemTitle , style: TextStyle(fontSize: 14 , fontFamily: 'Poppins', color: UiConstants.mainTextColor),),
              SizedBox(height: 6.0),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: List.generate(tags.length, (index) => TagBox(tag: tags[index],)) ,
                ),
              ),
              SizedBox(height: 8.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Solved: ${solved.toStringAsFixed(0)} students" , style: TextStyle(color: UiConstants.statTextColor , fontSize: 12),),
                  SizedBox(width: 12.0),

                  LikedAndDislikedButtons(
                    isLiked: isLiked,
                    isDisliked: isDisliked,
                    likedCount: liked.toInt(),
                    dislikedCount: disliked.toInt(),
                    onLike: () {
                      // Handle like action
                    },
                    onDislike: () {
                      // Handle disli ke action
                    },
                  ),
                ],
              ),
              NormalButtons(title: "View Details", onPressed: () {
                // Handle view details action
              })
            ],
          )
        ],
      ),
    );
  }
}