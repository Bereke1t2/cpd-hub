import 'package:flutter/material.dart';
import 'package:lab_portal/future/main/presentation/page/base_page.dart';
import 'package:lab_portal/future/main/presentation/widget/search.dart';

import '../widget/problem_container.dart';

class ProblemsPage extends StatelessWidget {
  final List<Map<String, String>> problems = [
    {'title': 'Two Sum', 'difficulty': 'Easy' , 'timestamp': DateTime.now().subtract(Duration(days: 1)).toString() , 'isSolved': true.toString() , 'likedCount': 5.toString() , 'dislikedCount': 1.toString() , },
    {'title': 'Longest Substring Without Repeating Characters', 'difficulty': 'Medium', 'timestamp': DateTime.now().subtract(Duration(days: 2)).toString(), 'isSolved': 'false', 'likedCount': 3.toString() , 'dislikedCount': 0.toString() },
    {'title': 'Median of Two Sorted Arrays', 'difficulty': 'Hard', 'timestamp': DateTime.now().subtract(Duration(days: 3)).toString(), 'isSolved': 'true', 'likedCount': 8.toString() , 'dislikedCount': 2.toString() },
    {'title': 'Valid Parentheses', 'difficulty': 'Easy', 'timestamp': DateTime.now().subtract(Duration(days: 4)).toString(), 'isSolved': 'false', 'likedCount': 1.toString() , 'dislikedCount': 1.toString() },
    {'title': 'Merge k Sorted Lists', 'difficulty': 'Hard', 'timestamp': DateTime.now().subtract(Duration(days: 5)).toString(), 'isSolved': 'true', 'likedCount': 4.toString() , 'dislikedCount': 0.toString() },
    {'title': 'Search in Rotated Sorted Array', 'difficulty': 'Medium', 'timestamp': DateTime.now().subtract(Duration(days: 6)).toString(), 'isSolved': 'true', 'likedCount': 6.toString() , 'dislikedCount': 1.toString() },
    {'title': 'Container With Most Water', 'difficulty': 'Medium', 'timestamp': DateTime.now().subtract(Duration(days: 7)).toString(), 'isSolved': 'true', 'likedCount': 7.toString() , 'dislikedCount': 0.toString() },
    {'title': 'Climbing Stairs', 'difficulty': 'Easy', 'timestamp': DateTime.now().subtract(Duration(days: 8)).toString(), 'isSolved': 'false', 'likedCount': 2.toString() , 'dislikedCount': 2.toString() },
    {'title': 'Word Ladder', 'difficulty': 'Hard', 'timestamp': DateTime.now().subtract(Duration(days: 9)).toString(), 'isSolved': 'false', 'likedCount': 3.toString() , 'dislikedCount': 1.toString() },
    {'title': 'Maximum Subarray', 'difficulty': 'Easy', 'timestamp': DateTime.now().subtract(Duration(days: 10)).toString(), 'isSolved': 'false', 'likedCount': 5.toString() , 'dislikedCount': 3.toString() },
  ];
   ProblemsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BasePage(
      selectedIndex: 1,
      title: 'Problems',
      subtitle: 'Explore and solve coding challenges',
      body: Column(
        children: [
          const SearchBox(hintText: "Search problems..."),
          const SizedBox(height: 10),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: List.generate(10, (index) => ProblemContainer(
                  title: problems[index]['title']!,
                  difficulty: problems[index]['difficulty']!,
                  timestamp: DateTime.parse(problems[index]['timestamp']!),
                  isSolved: problems[index]['isSolved']! == 'true',
                  likedCount: int.parse(problems[index]['likedCount']!),
                  dislikedCount: int.parse(problems[index]['dislikedCount']!),
                  tags: ['Array', 'String' , 'Dynamic Programming'], // Example tags
                )),
              ),
            ),
          ),
        ],
      ),
    );
  }
}