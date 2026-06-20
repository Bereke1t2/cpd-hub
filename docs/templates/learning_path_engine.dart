// lib/features/learning/domain/service/learning_path_engine.dart
//
// Phase 9 — the brain behind "what do I learn next, and what before what?".
// PURE Dart: no Flutter, no I/O, no DateTime.now(). Trivially unit-testable
// (see Phase 9 DoD). Given the topic graph + the set of solved problem ids, it
// classifies every topic as completed / available / locked and exposes the
// "available frontier" that the skill tree renders as "Up next".

import '../entity/topic_entity.dart';

enum TopicStatus {
  completed, // enough problems solved (>= threshold)
  available, // every prerequisite is completed → start this now
  locked,    // at least one prerequisite is unmet
}

class TopicProgress {
  final TopicStatus status;
  final int solved;
  final int total;
  final List<String> unmetPrerequisiteIds; // empty unless locked

  const TopicProgress({
    required this.status,
    required this.solved,
    required this.total,
    this.unmetPrerequisiteIds = const [],
  });

  double get ratio => total == 0 ? 0 : solved / total;
}

class LearningPathEngine {
  /// Fraction of a topic's mapped problems needed to count it "completed".
  final double completionThreshold;

  const LearningPathEngine({this.completionThreshold = 0.6});

  /// Classify every topic. Returns a map keyed by topic id.
  ///
  /// A topic is:
  ///  - completed: ratio >= completionThreshold
  ///  - available: not completed AND all prerequisiteIds are completed
  ///  - locked:    not completed AND >=1 prerequisite not completed
  Map<String, TopicProgress> classify(
    List<TopicEntity> topics,
    Set<String> solvedProblemIds,
  ) {
    final byId = {for (final t in topics) t.id: t};

    // Pass 1: solved/total + provisional completed flag (independent of prereqs).
    final solvedCount = <String, int>{};
    final completed = <String>{};
    for (final t in topics) {
      final n = t.problemIds.where(solvedProblemIds.contains).length;
      solvedCount[t.id] = n;
      final ratio = t.problemIds.isEmpty ? 0.0 : n / t.problemIds.length;
      if (ratio >= completionThreshold) completed.add(t.id);
    }

    // Pass 2: derive status from prerequisite completion.
    final result = <String, TopicProgress>{};
    for (final t in topics) {
      final solved = solvedCount[t.id] ?? 0;
      final total = t.problemIds.length;

      if (completed.contains(t.id)) {
        result[t.id] = TopicProgress(
          status: TopicStatus.completed,
          solved: solved,
          total: total,
        );
        continue;
      }

      final unmet = t.prerequisiteIds
          .where((p) => byId.containsKey(p) && !completed.contains(p))
          .toList();

      result[t.id] = TopicProgress(
        status: unmet.isEmpty ? TopicStatus.available : TopicStatus.locked,
        solved: solved,
        total: total,
        unmetPrerequisiteIds: unmet,
      );
    }
    return result;
  }

  /// The "Up next" strip: available topics, easiest first.
  List<TopicEntity> frontier(
    List<TopicEntity> topics,
    Map<String, TopicProgress> progress,
  ) {
    final avail = topics
        .where((t) => progress[t.id]?.status == TopicStatus.available)
        .toList()
      ..sort((a, b) => a.difficulty.compareTo(b.difficulty));
    return avail;
  }

  /// Overall curriculum completion (for a header progress bar / ring).
  double overallRatio(Map<String, TopicProgress> progress) {
    if (progress.isEmpty) return 0;
    final done = progress.values.where((p) => p.status == TopicStatus.completed).length;
    return done / progress.length;
  }

  /// DAG guard (call in debug + a unit test). Returns the ids that participate
  /// in a cycle, or [] if the graph is acyclic. A non-empty result must fail
  /// loudly — a cycle silently locks an entire category.
  List<String> detectCycle(List<TopicEntity> topics) {
    final byId = {for (final t in topics) t.id: t};
    final visiting = <String>{};
    final done = <String>{};
    final inCycle = <String>{};

    bool dfs(String id) {
      if (done.contains(id)) return false;
      if (visiting.contains(id)) {
        inCycle.add(id);
        return true;
      }
      visiting.add(id);
      for (final p in byId[id]?.prerequisiteIds ?? const <String>[]) {
        if (byId.containsKey(p) && dfs(p)) inCycle.add(id);
      }
      visiting.remove(id);
      done.add(id);
      return inCycle.contains(id);
    }

    for (final t in topics) {
      dfs(t.id);
    }
    return inCycle.toList();
  }
}
