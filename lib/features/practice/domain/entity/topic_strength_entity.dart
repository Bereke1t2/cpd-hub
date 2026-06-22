import 'package:equatable/equatable.dart';

class TopicStrengthEntity extends Equatable {
  final String topicId;
  final String topicName;
  final String category;

  /// 0..1 — higher is stronger.
  final double mastery;

  final int attempted;
  final int solved;

  /// Human-readable one-line explanation shown in the UI.
  final String explanation;

  const TopicStrengthEntity({
    required this.topicId,
    required this.topicName,
    required this.category,
    required this.mastery,
    required this.attempted,
    required this.solved,
    required this.explanation,
  });

  @override
  List<Object?> get props =>
      [topicId, topicName, category, mastery, attempted, solved, explanation];
}
