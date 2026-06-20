import 'package:equatable/equatable.dart';

class LadderRungEntity extends Equatable {
  final String problemId;
  final int rating;
  final bool solved;

  /// Optional link into Phase-9 topic graph.
  final String? topicId;

  const LadderRungEntity({
    required this.problemId,
    required this.rating,
    required this.solved,
    this.topicId,
  });

  LadderRungEntity copyWith({bool? solved}) =>
      LadderRungEntity(
        problemId: problemId,
        rating: rating,
        solved: solved ?? this.solved,
        topicId: topicId,
      );

  @override
  List<Object?> get props => [problemId, rating, solved, topicId];
}

class LadderEntity extends Equatable {
  final String id;
  final String title;
  final int fromRating;
  final int toRating;

  /// Ordered rungs, easiest first.
  final List<LadderRungEntity> rungs;

  const LadderEntity({
    required this.id,
    required this.title,
    required this.fromRating,
    required this.toRating,
    required this.rungs,
  });

  /// First unsolved rung — the "today's rung". Null when all solved.
  LadderRungEntity? get todaysRung {
    try {
      return rungs.firstWhere((r) => !r.solved);
    } catch (_) {
      return null;
    }
  }

  int get solvedCount => rungs.where((r) => r.solved).length;
  double get ratio => rungs.isEmpty ? 0 : solvedCount / rungs.length;

  LadderEntity withRungSolved(String problemId) => LadderEntity(
        id: id,
        title: title,
        fromRating: fromRating,
        toRating: toRating,
        rungs: rungs
            .map((r) => r.problemId == problemId ? r.copyWith(solved: true) : r)
            .toList(),
      );

  @override
  List<Object?> get props => [id, title, fromRating, toRating, rungs];
}
