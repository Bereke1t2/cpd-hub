import 'package:equatable/equatable.dart';

class UpsolveItemEntity extends Equatable {
  final String contestId;
  final String contestTitle;
  final String problemId;
  final String problemTitle;

  /// True once the user solves this problem after the contest.
  final bool resolved;

  const UpsolveItemEntity({
    required this.contestId,
    required this.contestTitle,
    required this.problemId,
    required this.problemTitle,
    required this.resolved,
  });

  UpsolveItemEntity markResolved() => UpsolveItemEntity(
        contestId: contestId,
        contestTitle: contestTitle,
        problemId: problemId,
        problemTitle: problemTitle,
        resolved: true,
      );

  @override
  List<Object?> get props =>
      [contestId, contestTitle, problemId, problemTitle, resolved];
}
