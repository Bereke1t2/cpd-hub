// Pure Dart — no Flutter, no I/O.
// Picks the next problems to practice: weak topic × available × unsolved.

import 'package:lab_portal/features/learning/domain/entity/topic_entity.dart';
import 'package:lab_portal/features/learning/domain/service/learning_path_engine.dart';
import '../entity/recommendation_entity.dart';
import '../entity/solve_history.dart';
import '../entity/topic_strength_entity.dart';

class Recommender {
  const Recommender();

  /// Returns up to [count] recommendations.
  ///
  /// Strategy:
  ///   1. Prefer available topics (prereqs met) sorted weakest-first.
  ///   2. Within each topic pick unsolved problems.
  ///   3. Fall back to frontier topics with 0 progress when history is thin.
  List<RecommendationEntity> next(
    List<TopicEntity> topics,
    List<TopicStrengthEntity> strengths,
    Map<String, TopicProgress> graphProgress,
    SolveHistory history, {
    int count = 5,
  }) {
    final topicById = {for (final t in topics) t.id: t};
    final strengthById = {for (final s in strengths) s.topicId: s};
    final results = <RecommendationEntity>[];
    final seen = <String>{};

    // Available topics, ordered weak→strong (strengths list is already sorted).
    final availableIds = graphProgress.entries
        .where((e) => e.value.status == TopicStatus.available)
        .map((e) => e.key)
        .toList()
      ..sort((a, b) {
        final ma = strengthById[a]?.mastery ?? 0;
        final mb = strengthById[b]?.mastery ?? 0;
        return ma.compareTo(mb); // weakest first
      });

    for (final topicId in availableIds) {
      if (results.length >= count) break;
      final topic = topicById[topicId];
      if (topic == null) continue;
      final strength = strengthById[topicId];

      for (final pid in topic.problemIds) {
        if (results.length >= count) break;
        if (seen.contains(pid)) continue;
        if (history.hasSolved(pid)) continue;

        seen.add(pid);
        results.add(RecommendationEntity(
          problemId: pid,
          topicId: topicId,
          topicName: topic.name,
          difficulty: _difficulty(topic.difficulty),
          reason: _reason(topic.name, strength),
        ));
      }
    }

    // If still short, pull from completed topics (unsolved problems still exist).
    if (results.length < count) {
      for (final topic in topics) {
        if (results.length >= count) break;
        final prog = graphProgress[topic.id];
        if (prog == null || prog.status == TopicStatus.locked) continue;
        for (final pid in topic.problemIds) {
          if (results.length >= count) break;
          if (seen.contains(pid) || history.hasSolved(pid)) continue;
          seen.add(pid);
          results.add(RecommendationEntity(
            problemId: pid,
            topicId: topic.id,
            topicName: topic.name,
            difficulty: _difficulty(topic.difficulty),
            reason: 'More practice in ${topic.name} will cement it.',
          ));
        }
      }
    }

    return results;
  }

  String _difficulty(int d) {
    if (d <= 1) return 'Easy';
    if (d <= 3) return 'Medium';
    return 'Hard';
  }

  String _reason(String topicName, TopicStrengthEntity? strength) {
    if (strength == null || strength.solved == 0) {
      return 'Start building $topicName — prerequisites are met.';
    }
    if (strength.mastery < 0.4) {
      return 'Weakest available topic — focus on $topicName now.';
    }
    if (strength.mastery < 0.7) {
      return 'Still gaps in $topicName (${(strength.mastery * 100).round()}% done).';
    }
    return 'Almost mastered $topicName — finish the remaining problems.';
  }
}
