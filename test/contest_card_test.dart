import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lab_portal/core/ui_constants.dart';
import 'package:lab_portal/future/main/domain/entity/contest_entity.dart';
import 'package:lab_portal/future/main/presentation/widget/contest_card.dart';

ContestEntity _contest({
  required Duration startIn,
  String duration = '02:00:00',
  String platform = 'Codeforces',
}) {
  final start = DateTime.now().toUtc().add(startIn);
  return ContestEntity(
    id: 'x',
    title: 'A Reasonably Long Contest Title That Might Wrap Across Lines',
    contestUrl: 'https://example.com',
    startTime: start.toIso8601String(),
    duration: duration,
    platform: platform,
    numberOfProblems: 6,
    isPast: false,
    isParticipating: true,
  );
}

Widget _harness(Widget child, {double width = 320}) => MaterialApp(
      home: Scaffold(
        backgroundColor: UiConstants.backgroundColor,
        body: MediaQuery(
          data: const MediaQueryData(textScaler: TextScaler.linear(1.4)),
          child: Center(child: SizedBox(width: width, child: child)),
        ),
      ),
    );

void main() {
  testWidgets('upcoming (imminent) contest card renders without overflow',
      (tester) async {
    await tester.pumpWidget(
        _harness(ContestCard(contest: _contest(startIn: const Duration(minutes: 4)))));
    await tester.pump(const Duration(seconds: 1));
    expect(tester.takeException(), isNull);
    expect(find.text('STARTS IN'), findsOneWidget);
  });

  testWidgets('upcoming (days away) shows DAYS segment, no overflow',
      (tester) async {
    await tester.pumpWidget(_harness(
        ContestCard(contest: _contest(startIn: const Duration(days: 2, hours: 3)))));
    await tester.pump(const Duration(seconds: 1));
    expect(tester.takeException(), isNull);
    expect(find.text('DAYS'), findsOneWidget);
  });

  testWidgets('live contest shows LIVE badge + ENDS IN, no overflow',
      (tester) async {
    // Started 10 min ago, 2h long → running.
    await tester.pumpWidget(_harness(
        ContestCard(contest: _contest(startIn: const Duration(minutes: -10)))));
    await tester.pump(const Duration(seconds: 1));
    expect(tester.takeException(), isNull);
    expect(find.text('LIVE'), findsOneWidget);
    expect(find.text('ENDS IN'), findsOneWidget);
  });
}
