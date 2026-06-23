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

  /// [duration] arrives as "HH:MM:SS"; parse it into a real Duration.
  Duration get parsedDuration {
    final parts = duration.split(':');
    if (parts.length == 3) {
      return Duration(
        hours: int.tryParse(parts[0]) ?? 0,
        minutes: int.tryParse(parts[1]) ?? 0,
        seconds: int.tryParse(parts[2]) ?? 0,
      );
    }
    return Duration.zero;
  }

  /// When the contest is scheduled to finish.
  DateTime get endsAt => startsAt.add(parsedDuration);

  /// True when the contest hasn't started yet (time-based).
  bool get isUpcoming => DateTime.now().isBefore(startsAt);

  /// True when the contest has started but not yet ended — i.e. live now.
  bool get isRunning {
    final now = DateTime.now();
    return !now.isBefore(startsAt) && now.isBefore(endsAt);
  }

  /// True once the scheduled end time has passed.
  bool get hasEnded => DateTime.now().isAfter(endsAt);

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
