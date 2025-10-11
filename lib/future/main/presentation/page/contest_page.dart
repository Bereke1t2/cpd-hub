import 'package:flutter/material.dart';
import 'package:lab_portal/future/main/presentation/page/base_page.dart';
import 'package:lab_portal/future/main/presentation/widget/contest_box.dart';

import '../widget/bar_box.dart';

class ContestPage extends StatelessWidget {
  final List<Map<String, String>> contests = [
    {
      "title": "Weekly Coding Challenge 1",
      "date": DateTime.now().add(Duration(days: 3)).toString(),
      "participated": "false",
      "numberOfProblems": "5",
      "time": DateTime.now().add(Duration(hours: 2)).toString(),
      "numberOfContestants": "1",
    },
    {
      "title": "Weekly Coding Challenge 2",
      "date": DateTime.now().add(Duration(days: 4)).toString(),
      "participated": "true",
      "numberOfProblems": "5",
      "time": DateTime.now().add(Duration(hours: 3)).toString(),
      "numberOfContestants": "1",
    },
    {
      "title": "Weekly Coding Challenge 3",
      "date": DateTime.now().add(Duration(days: 5)).toString(),
      "participated": "true",
      "numberOfProblems": "5",
      "time": DateTime.now().add(Duration(hours: 4)).toString(),
      "numberOfContestants": "1",
    },
    {
      "title": "Weekly Coding Challenge 4",
      "date": DateTime.now().add(Duration(days: 6)).toString(),
      "participated": "true",
      "numberOfProblems": "5",
      "time": DateTime.now().add(Duration(hours: 5)).toString(),
      "numberOfContestants": "1",
    },
    {
      "title": "Weekly Coding Challenge 5",
      "date": DateTime.now().add(Duration(days: 7)).toString(),
      "participated": "false",
      "numberOfProblems": "5",
      "time": DateTime.now().add(Duration(hours: 6)).toString(),
      "numberOfContestants": "1",
    },
  ];
   ContestPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BasePage(
      title: "Contests",
      selectedIndex: 2,
      subtitle: "Upcoming contests",
      body: Column(
    
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              BarBox(text: "All", isSelected: true),
              SizedBox(width: 16),
              BarBox(text: "Div1", isSelected: false),
              SizedBox(width: 16),
              BarBox(text: "Div2", isSelected: false),
            ],
          ),

          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(16.0),
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Upcoming Contests',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white.withValues(alpha: 0.87),
                      ),
                    ),
                  ),
                  Column(
                    children: List.generate(contests.length, (index) {
                      final contest = contests[index];
                      return ContestBox(
                        title: contest["title"]!,
                        date: DateTime.parse(contest["date"]!),
                        participated: contest["participated"] == "true",
                        numberOfProblems: int.parse(contest["numberOfProblems"]!),
                        time: DateTime.parse(contest["time"]!),
                        numberOfContestants: int.parse(contest["numberOfContestants"]!),
                      );
                    }),
                  ),
                  Container(
                    padding: const EdgeInsets.all(16.0),
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Past Contests',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white.withValues(alpha: 0.87),
                      ),
                    ),
                  ),
                  Column(
                    children: List.generate(contests.length, (index) {
                      final contest = contests[index];
                      return ContestBox(
                        title: contest["title"]!,
                        date: DateTime.parse(contest["date"]!),
                        participated: contest["participated"] == "true",
                        numberOfProblems: int.parse(contest["numberOfProblems"]!),
                        time: DateTime.parse(contest["time"]!),
                        numberOfContestants: int.parse(contest["numberOfContestants"]!),
                      );
                    }),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}