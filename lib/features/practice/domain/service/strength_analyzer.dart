// Pure Dart — no Flutter, no I/O. Trivially unit-testable.
// Derives per-topic mastery from topic graph progress + solve history.

import 'package:lab_portal/features/learning/domain/entity/topic_entity.dart';
import 'package:lab_portal/features/learning/domain/service/learning_path_engine.dart';
import '../entity/solve_history.dart';
import '../entity/topic_strength_entity.dart';

class StrengthAnalyzer {
  const StrengthAnalyzer();

  /// Returns one [TopicStrengthEntity] per topic that has ≥1 problem mapped.
  /// Topics with no problems are skipped — no mastery can be computed.
  List<TopicStrengthEntity> analyze(
    List<TopicEntity> topics,
    Map<String, TopicProgress> progress,
    SolveHistory history,
  ) {
    final results = <TopicStrengthEntity>[];

    for (final topic in topics) {
      if (topic.problemIds.isEmpty) continue;

      final p = progress[topic.id];
      if (p == null) continue;

      final solved = p.solved;
      final total = p.total;
      final mastery = _mastery(solved, total);
      final explanation = _explain(topic.name, solved, total, mastery);

      results.add(TopicStrengthEntity(
        topicId: topic.id,
        topicName: topic.name,
        category: topic.category,
        mastery: mastery,
        attempted: total,
        solved: solved,
        explanation: explanation,
      ));
    }

    // Sort weakest first so the UI surfaces gaps first.
    results.sort((a, b) => a.mastery.compareTo(b.mastery));
    return results;
  }

  /// Weakest topics whose prerequisites are all completed (i.e. available).
  List<TopicStrengthEntity> weakAvailable(
    List<TopicStrengthEntity> strengths,
    Map<String, TopicProgress> progress,
  ) {
    return strengths
        .where((s) => progress[s.topicId]?.status == TopicStatus.available)
        .toList(); // already sorted weakest-first
  }

  double _mastery(int solved, int total) {
    if (total == 0) return 0;
    // Simple ratio for now. Extend with recency decay and try-count when
    // the backend tracks them.
    return (solved / total).clamp(0.0, 1.0);
  }

  String _explain(String name, int solved, int total, double mastery) {
    if (solved == 0) return 'No problems solved in $name yet.';
    if (mastery >= 0.8) return 'Strong in $name — $solved/$total problems solved.';
    if (mastery >= 0.5) return 'Progressing in $name — $solved/$total problems solved.';
    return 'Weak in $name — only $solved/$total problems solved. Focus here.';
  }
}
