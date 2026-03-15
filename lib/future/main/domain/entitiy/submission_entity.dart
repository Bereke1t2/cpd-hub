import 'package:equatable/equatable.dart';

class SubmissionEntity extends Equatable {
  final String id;
  final String problemId;
  final String problemTitle;
  final String
  status; // e.g., 'Accepted', 'Wrong Answer', 'Time Limit Exceeded'
  final String language;
  final String executionTime;
  final String memoryUsed;
  final String timestamp;

  const SubmissionEntity({
    required this.id,
    required this.problemId,
    required this.problemTitle,
    required this.status,
    required this.language,
    required this.executionTime,
    required this.memoryUsed,
    required this.timestamp,
  });

  @override
  List<Object?> get props => [
    id,
    problemId,
    problemTitle,
    status,
    language,
    executionTime,
    memoryUsed,
    timestamp,
  ];
}
