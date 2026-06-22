import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lab_portal/core/ui_constants.dart';
import 'package:lab_portal/features/learning/domain/entity/topic_entity.dart';
import 'package:lab_portal/features/learning/domain/service/learning_path_engine.dart';
import 'package:lab_portal/features/learning/presentation/widget/topic_node.dart';
import 'package:lab_portal/features/learning/presentation/widget/up_next_strip.dart';

// Long, worst-case content to stress horizontal layout.
const _longName = 'Heavy Light Decomposition with Persistent Segment Trees';
const _longCat = 'Advanced Tree Algorithms & Data Structures';

TopicEntity _topic() => const TopicEntity(
      id: 't1',
      name: _longName,
      category: _longCat,
      summary: 'x',
      difficulty: 5,
      prerequisiteIds: ['binary-search', 'segment-tree', 'lca'],
      problemIds: [],
      referenceUrls: [],
    );

Widget _harness(Widget child, {double width = 320, double scale = 1.6}) {
  return MaterialApp(
    home: Scaffold(
      backgroundColor: UiConstants.backgroundColor,
      body: MediaQuery(
        data: MediaQueryData(textScaler: TextScaler.linear(scale)),
        child: Center(
          child: SizedBox(width: width, child: child),
        ),
      ),
    ),
  );
}

void main() {
  testWidgets('TopicNode — narrow + large text', (tester) async {
    await tester.pumpWidget(_harness(
      TopicNode(
        topic: _topic(),
        progress: const TopicProgress(
          status: TopicStatus.available,
          solved: 3,
          total: 8,
        ),
        onTap: () {},
      ),
    ));
    expect(tester.takeException(), isNull, reason: 'TopicNode overflowed');
  });

  testWidgets('TopicNode locked with prereqs', (tester) async {
    await tester.pumpWidget(_harness(
      TopicNode(
        topic: _topic(),
        progress: const TopicProgress(
          status: TopicStatus.locked,
          solved: 0,
          total: 8,
          unmetPrerequisiteIds: ['binary-search', 'segment-tree', 'lca'],
        ),
        onTap: () {},
      ),
    ));
    expect(tester.takeException(), isNull, reason: 'TopicNode(locked) overflowed');
  });

  testWidgets('UpNextStrip — large text', (tester) async {
    await tester.pumpWidget(_harness(
      UpNextStrip(frontier: [_topic()], onTap: (_) {}),
      width: 360,
    ));
    expect(tester.takeException(), isNull, reason: 'UpNextStrip overflowed');
  });
}
