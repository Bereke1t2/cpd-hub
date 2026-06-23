import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lab_portal/core/ui_constants.dart';
import 'package:lab_portal/future/main/domain/entity/problem_entity.dart';
import 'package:lab_portal/future/main/presentation/page/problems_page.dart';

ProblemEntity _problem({
  String title = 'Two Sum',
  String difficulty = 'Easy',
  List<String> tags = const ['array', 'hash-table', 'two-pointers'],
  int likes = 1234,
  int solved = 56000,
  bool solvedByUser = false,
}) {
  return ProblemEntity(
    title: title,
    difficulty: difficulty,
    tags: tags,
    numberOfLikes: likes,
    numberOfDislikes: 3,
    problemUrl: 'https://example.com',
    problemId: 'p1',
    isLiked: false,
    isDisliked: false,
    isSolved: solvedByUser,
    numberOfSolvedPeople: solved,
  );
}

Widget _harness(Widget child,
        {double width = 320, double textScale = 1.4}) =>
    MaterialApp(
      home: Scaffold(
        backgroundColor: UiConstants.backgroundColor,
        body: MediaQuery(
          data: MediaQueryData(textScaler: TextScaler.linear(textScale)),
          child: Center(child: SizedBox(width: width, child: child)),
        ),
      ),
    );

void main() {
  testWidgets('ProblemCard renders without overflow on a narrow phone + big text',
      (tester) async {
    await tester.pumpWidget(_harness(ProblemCard(problem: _problem())));
    await tester.pump();
    expect(tester.takeException(), isNull);
    expect(find.text('Easy'), findsOneWidget);
  });

  testWidgets('ProblemCard with a long title + many tags does not overflow',
      (tester) async {
    await tester.pumpWidget(_harness(ProblemCard(
      problem: _problem(
        title:
            'Maximum Sum of a Contiguous Subarray With Some Very Long Title',
        difficulty: 'Hard',
        tags: const [
          'dynamic-programming',
          'divide-and-conquer',
          'greedy',
          'sliding-window',
          'prefix-sum',
        ],
      ),
    )));
    await tester.pump();
    expect(tester.takeException(), isNull);
    expect(find.text('Hard'), findsOneWidget);
  });

  testWidgets('solved ProblemCard shows the solved indicator', (tester) async {
    await tester.pumpWidget(
        _harness(ProblemCard(problem: _problem(solvedByUser: true))));
    await tester.pump();
    expect(tester.takeException(), isNull);
    expect(find.byIcon(Icons.check_circle_rounded), findsOneWidget);
  });

  testWidgets('ProblemCard fits a wide grid tile (mainAxisExtent 156)',
      (tester) async {
    // Mirror the grid tile the page builds: ~500 wide, 156 tall.
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: MediaQuery(
          data: const MediaQueryData(textScaler: TextScaler.linear(1.2)),
          child: Center(
            child: SizedBox(
              width: 500,
              height: 156,
              child: ProblemCard(problem: _problem()),
            ),
          ),
        ),
      ),
    ));
    await tester.pump();
    expect(tester.takeException(), isNull);
  });
}
