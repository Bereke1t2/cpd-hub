import 'package:flutter/material.dart';
import 'package:lab_portal/future/main/presentation/widget/problem_box.dart';

import '../../../../core/ui_constants.dart';
import '../widget/info_box.dart';
import '../widget/todays_problem_box.dart';
import '../widget/welcomback_box.dart';
import 'base_page.dart';

class HomePage extends StatefulWidget {

  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Map<String, String>> problems = [
    {'title': 'Two Sum', 'difficulty': 'Easy' , 'isLiked': 'false', 'isDisliked': 'false'},
    {'title': 'Longest Substring Without Repeating Characters', 'difficulty': 'Medium', 'isLiked': 'false', 'isDisliked': 'false'},
    {'title': 'Median of Two Sorted Arrays', 'difficulty': 'Hard', 'isLiked': 'false', 'isDisliked': 'false'},
    {'title': 'Valid Parentheses', 'difficulty': 'Easy', 'isLiked': 'false', 'isDisliked': 'false'},
    {'title': 'Merge k Sorted Lists', 'difficulty': 'Hard', 'isLiked': 'false', 'isDisliked': 'false'},
    {'title': 'Search in Rotated Sorted Array', 'difficulty': 'Medium', 'isLiked': 'false', 'isDisliked': 'false'},
    {'title': 'Container With Most Water', 'difficulty': 'Medium', 'isLiked': 'false', 'isDisliked': 'false'},
    {'title': 'Climbing Stairs', 'difficulty': 'Easy', 'isLiked': 'false', 'isDisliked': 'false'},
    {'title': 'Word Ladder', 'difficulty': 'Hard', 'isLiked': 'false', 'isDisliked': 'false'},
    {'title': 'Maximum Subarray', 'difficulty': 'Easy', 'isLiked': 'false', 'isDisliked': 'false'},
  ];

  @override
  Widget build(BuildContext context) {
    return BasePage(
      selectedIndex: 0,
      title: 'Home',
      subtitle: 'Ready to solve today?',
      body: SingleChildScrollView(
        child: Column(
          children: [
            const WelcomeBackBox(name: 'Bereket'), // Example usage with a name
            const InfoBox(
              title: 'Problem Solving',
              description: 'Let\'s tackle today\'s challenges together!',
            ),
            const InfoBox(
              title: 'Todays Contest',
              description: 'Join the contest and test your skills against others!... to participate, click the button below. follow this 3 rules: 1. No plagiarism 2. No external help 3. Submit within the time limit',
            ),
            const TodaysProblemBox(
              problemTitle: 'Sample Problem Title',
              solved: 75,
              tags: ['Array', 'String', 'Dynamic Programming'],
              liked: 90,
              disliked: 10,
              difficulty: 'Medium',
              isLiked: false,
              isDisliked: false,
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 12.0),
              width: double.infinity,
              padding: const EdgeInsets.only(left:0.0 , top:16),
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(12.0)),
                color: UiConstants.infoBackgroundColor,
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(left: 8.0),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(6.0),
                              decoration: BoxDecoration(
                                color: UiConstants.primaryButtonColor.withOpacity(0.18),
                                borderRadius: BorderRadius.circular(4.0),
                              ),
                              child: const Icon(Icons.grid_view, color: UiConstants.statTextColor, size: 20),
                            ),
                            const SizedBox(width: 12.0),
                            Text(
                              "All Problems",
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: UiConstants.mainTextColor),
                            ),
                          ],
                        ),
                      ),
                      Icon(Icons.arrow_drop_down, color: UiConstants.subtitleTextColor),
                    ],
                  ),
                  SizedBox(height: 12.0),
                  Column(
                    children: List.generate(problems.length, (index) {
                      final problem = problems[index];
                      return ProblemBox(
                        title: problem['title']!,
                        difficulty: problem['difficulty']!,
                      );
                    }),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, '/problems');
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16),
                      decoration: BoxDecoration(
                      color: UiConstants.primaryButtonColor.withOpacity(0.10),
                      borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                        'See more',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: UiConstants.primaryButtonColor,
                        ),
                        ),
                        const SizedBox(width: 6),
                        Icon(
                        Icons.arrow_forward_rounded,
                        size: 18,
                        color: UiConstants.primaryButtonColor,
                        ),
                      ],
                      ),
                    ),
                    ),

                ],
              )
            ),
          ],
        ),
      ),
    );
  }
}