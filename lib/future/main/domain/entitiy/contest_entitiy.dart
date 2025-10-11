import 'package:equatable/equatable.dart';

class ContestEntitiy extends Equatable{
  final String title;
  final String contestUrl;
  final String startTime;
  final String duration;
  final String platform;
  final int numberOfProblems;
  final bool isPast;
  final bool isParticipating;

  const ContestEntitiy({
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