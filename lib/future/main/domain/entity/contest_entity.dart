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

  /// Parsed start time in local timezone. Use this everywhere instead of
  /// calling DateTime.tryParse(startTime) at each call site.
  DateTime get startsAt =>
      (DateTime.tryParse(startTime) ?? DateTime.now()).toLocal();

  /// True when the contest hasn't started yet.
  bool get isUpcoming => !isPast && startsAt.isAfter(DateTime.now());

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
