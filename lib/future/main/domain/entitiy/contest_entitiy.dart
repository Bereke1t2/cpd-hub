import 'package:equatable/equatable.dart';

class ContestEntitiy extends Equatable {
  final String id;
  final String title;
  final String contestUrl;
  final String startTime;
  final String duration;
  final String platform;
  final int numberOfProblems;
  final int numberOfContestants;
  final String date;
  final bool isPast;
  final bool isParticipating;

  const ContestEntitiy({
    required this.id,
    required this.title,
    required this.contestUrl,
    required this.startTime,
    required this.duration,
    required this.platform,
    required this.numberOfProblems,
    required this.numberOfContestants,
    required this.date,
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
        numberOfContestants,
        date,
        isPast,
        isParticipating,
      ];
}