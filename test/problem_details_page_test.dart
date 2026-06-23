import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:lab_portal/core/di/injection.dart';
import 'package:lab_portal/future/main/domain/entity/problem_entity.dart';
import 'package:lab_portal/future/main/presentation/bloc/bookmarks/bookmarks_cubit.dart';
import 'package:lab_portal/future/main/presentation/page/problem_details_page.dart';

ProblemEntity _problem({
  String title = 'Two Sum',
  String difficulty = 'Easy',
  List<String> tags = const ['array', 'hash-table'],
  int likes = 1234,
  int solved = 56000,
  bool solved_ = false,
}) {
  return ProblemEntity(
    title: title,
    difficulty: difficulty,
    tags: tags,
    numberOfLikes: likes,
    numberOfDislikes: 12,
    problemUrl: 'https://example.com',
    problemId: 'p1',
    isLiked: false,
    isDisliked: false,
    isSolved: solved_,
    numberOfSolvedPeople: solved,
  );
}

Widget _app(Widget child, {required Size size, double textScale = 1.3}) {
  return MaterialApp(
    home: MediaQuery(
      data: MediaQueryData(
        size: size,
        textScaler: TextScaler.linear(textScale),
      ),
      child: child,
    ),
  );
}

void main() {
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    if (!getIt.isRegistered<BookmarksCubit>()) {
      getIt.registerFactory<BookmarksCubit>(() => BookmarksCubit(prefs));
    }
  });

  testWidgets('details page renders without overflow on a phone + big text',
      (tester) async {
    tester.view.physicalSize = const Size(360, 1800);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(_app(
      ProblemDetailsPage(problem: _problem()),
      size: const Size(360, 1800),
    ));
    await tester.pump();

    expect(tester.takeException(), isNull);
    expect(find.text('Easy'), findsOneWidget);
    expect(find.text('Open Problem'), findsOneWidget);
    expect(find.text('Mark Solved'), findsOneWidget);
  });

  testWidgets('details page with many tags + big numbers does not overflow',
      (tester) async {
    tester.view.physicalSize = const Size(360, 2200);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(_app(
      ProblemDetailsPage(
        problem: _problem(
          title: 'Maximum Subarray Sum',
          difficulty: 'Hard',
          tags: const [
            'dynamic-programming',
            'greedy',
            'divide-and-conquer',
            'array',
          ],
          likes: 1500000,
          solved: 2400000,
          solved_: true,
        ),
      ),
      size: const Size(360, 2200),
    ));
    await tester.pump();

    expect(tester.takeException(), isNull);
    expect(find.text('Hard'), findsOneWidget);
    expect(find.text('Mark Unsolved'), findsOneWidget);
  });

  testWidgets('details page renders the two-column layout when wide',
      (tester) async {
    tester.view.physicalSize = const Size(1000, 1400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(_app(
      ProblemDetailsPage(problem: _problem()),
      size: const Size(1000, 1400),
      textScale: 1.1,
    ));
    await tester.pump();

    expect(tester.takeException(), isNull);
    expect(find.text('Hints'), findsOneWidget);
    expect(find.text('Stats'), findsOneWidget);
  });
}
