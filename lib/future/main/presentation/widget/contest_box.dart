import 'package:flutter/material.dart';
import 'package:lab_portal/core/ui_constants.dart';

class ContestBox extends StatelessWidget {
  final String title;
  final bool participated;
  final DateTime date;
  final int numberOfProblems;
  final DateTime time;
  final int numberOfContestants;
  const ContestBox({super.key, required this.title, required this.participated, required this.date, required this.numberOfProblems, required this.time, required this.numberOfContestants });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 16.0),
      decoration: BoxDecoration(
        color: UiConstants.infoBackgroundColor,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('$numberOfContestants. $title' , style: TextStyle(fontSize: 16 , fontWeight: FontWeight.bold , color: UiConstants.mainTextColor),),
              Icon(participated ? Icons.check_circle : Icons.radio_button_unchecked, color: participated ? Colors.green.shade400 :UiConstants.infoBackgroundColor , size: 20.0,),
            ],
          ),
          SizedBox(height: 8.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("$numberOfProblems problems . ${DateTime.now().difference(date).inHours} hours ago " , style: TextStyle(color: UiConstants.subtitleTextColor , fontSize: 12),),
            ],
          ),
        ],
      ),
    );
  }
}