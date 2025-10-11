import '../../domain/entitiy/contest_entitiy.dart';

class ContestModel extends ContestEntitiy {
  const ContestModel({
    required super.title,
    required super.contestUrl,
    required super.startTime,
    required super.duration,
    required super.platform,
    required super.numberOfProblems,
    required super.isPast,
    required super.isParticipating,
  });

  factory ContestModel.fromJson(Map<String, dynamic> json) {
    return ContestModel(
      title: json['title'] ?? '',
      contestUrl: json['contestUrl'] ?? '',
      startTime: json['startTime'] ?? '',
      duration: json['duration'] ?? '',
      platform: json['platform'] ?? '',
      numberOfProblems: json['numberOfProblems'] ?? 0,
      isPast: json['isPast'] ?? false,
      isParticipating: json['isParticipating'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'contestUrl': contestUrl,
      'startTime': startTime,
      'duration': duration,
      'platform': platform,
      'numberOfProblems': numberOfProblems,
      'isPast': isPast,
      'isParticipating': isParticipating,
    };
  }
}