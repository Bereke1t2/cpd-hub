// Pure Dart — no Flutter, no I/O. Trivially unit-testable.
// Left = success is a repo concern; this service just computes.

import '../entity/topic_entity.dart';

enum TopicStatus { completed, available, locked }

class TopicProgress {
  final TopicStatus status;
  final int solved;
  final int total;

  /// Ids of prerequisites that are not yet completed (non-empty only when locked).
  final List<String> unmetPrerequisiteIds;

  const TopicProgress({
    required this.status,
    required this.solved,
    required this.total,
    this.unmetPrerequisiteIds = const [],
  });

  double get ratio => total == 0 ? 0.0 : solved / total;
}

class LearningPathEngine {
  /// Fraction of mapped problems that must be solved to count a topic "completed".
  final double completionThreshold;

  const LearningPathEngine({this.completionThreshold = 0.6});

  /// Classify every topic. Returns a map keyed by [TopicEntity.id].
  Map<String, TopicProgress> classify(
    List<TopicEntity> topics,
    Set<String> solvedProblemIds,
  ) {
    final byId = {for (final t in topics) t.id: t};

    // Pass 1 — compute solved/total and mark topics as completed independent of prereqs.
    final solvedCount = <String, int>{};
    final completed = <String>{};

    for (final t in topics) {
      final n = t.problemIds.where(solvedProblemIds.contains).length;
      solvedCount[t.id] = n;
      final ratio = t.problemIds.isEmpty ? 1.0 : n / t.problemIds.length;
      if (ratio >= completionThreshold) completed.add(t.id);
    }

    // Pass 2 — derive status from prereq completion.
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

  /// The "Up next" frontier — available topics sorted easiest first.
  List<TopicEntity> frontier(
    List<TopicEntity> topics,
    Map<String, TopicProgress> progress,
  ) {
    return topics
        .where((t) => progress[t.id]?.status == TopicStatus.available)
        .toList()
      ..sort((a, b) => a.difficulty.compareTo(b.difficulty));
  }

  /// 0..1 overall curriculum completion ratio.
  double overallRatio(Map<String, TopicProgress> progress) {
    if (progress.isEmpty) return 0.0;
    final done =
        progress.values.where((p) => p.status == TopicStatus.completed).length;
    return done / progress.length;
  }

  /// Returns ids involved in a cycle, or [] if the graph is acyclic.
  /// Call this in debug mode and in tests — a cycle silently locks everything.
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
