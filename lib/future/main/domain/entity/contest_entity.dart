import 'package:equatable/equatable.dart';

class ContestEntity extends Equatable {
  /// Backend contest ID used for leaderboard lookup (e.g. "codeforces-1932").
  final String id;
  final String title;
  final String contestUrl;
  final String startTime;
  final String duration;
  final String platform;
  final int numberOfProblems;
  final bool isPast;
  final bool isParticipating;

  const ContestEntity({
    required this.id,
    required this.title,
    required this.contestUrl,
    required this.startTime,
    required this.duration,
    required this.platform,
    required this.numberOfProblems,
    required this.isPast,
    required this.isParticipating,
  });

  @override
  List<Object?> get props => [
        id,
        title,
        contestUrl,
        startTime,
        duration,
        platform,
        numberOfProblems,
        isPast,
        isParticipating,
      ];
}
