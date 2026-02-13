import '../../domain/entitiy/submission_entity.dart';

class SubmissionModel extends SubmissionEntity {
  const SubmissionModel({
    required super.id,
    required super.problemId,
    required super.problemTitle,
    required super.status,
    required super.language,
    required super.executionTime,
    required super.memoryUsed,
    required super.timestamp,
  });

  factory SubmissionModel.fromJson(Map<String, dynamic> json) {
    return SubmissionModel(
      id: (json['id'] ?? '') as String,
      problemId: (json['problemId'] ?? '') as String,
      problemTitle: (json['problemTitle'] ?? '') as String,
      status: (json['status'] ?? '') as String,
      language: (json['language'] ?? '') as String,
      executionTime: (json['executionTime'] ?? '') as String,
      memoryUsed: (json['memoryUsed'] ?? '') as String,
      timestamp: (json['timestamp'] ?? '') as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'problemId': problemId,
      'problemTitle': problemTitle,
      'status': status,
      'language': language,
      'executionTime': executionTime,
      'memoryUsed': memoryUsed,
      'timestamp': timestamp,
    };
  }
}
