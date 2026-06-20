import 'package:equatable/equatable.dart';

class TopicEntity extends Equatable {
  /// Slug-style unique id, e.g. 'binary-search'.
  final String id;
  final String name;

  /// High-level grouping shown as a swimlane, e.g. 'Graphs', 'DP', 'Strings'.
  final String category;

  /// One-paragraph "what it is and why it matters".
  final String summary;

  /// 1 = easiest within category, 5 = hardest. Used to sort the "Up next" frontier.
  final int difficulty;

  /// Ids of topics that must be completed before this one unlocks.
  final List<String> prerequisiteIds;

  /// Problem ids (→ ProblemEntity.problemId) mapped to this topic, easy→hard.
  final List<String> problemIds;

  /// External links: cp-algorithms, USACO Guide, etc.
  final List<String> referenceUrls;

  const TopicEntity({
    required this.id,
    required this.name,
    required this.category,
    required this.summary,
    required this.difficulty,
    required this.prerequisiteIds,
    required this.problemIds,
    required this.referenceUrls,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        category,
        summary,
        difficulty,
        prerequisiteIds,
        problemIds,
        referenceUrls,
      ];
}
