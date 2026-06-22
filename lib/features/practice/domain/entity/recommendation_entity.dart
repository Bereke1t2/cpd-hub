import 'package:equatable/equatable.dart';

class RecommendationEntity extends Equatable {
  final String problemId;
  final String topicId;
  final String topicName;

  /// Why this problem was chosen — always shown. No black-box recommendations.
  final String reason;

  final String difficulty;

  const RecommendationEntity({
    required this.problemId,
    required this.topicId,
    required this.topicName,
    required this.reason,
    required this.difficulty,
  });

  @override
  List<Object?> get props =>
      [problemId, topicId, topicName, reason, difficulty];
}
