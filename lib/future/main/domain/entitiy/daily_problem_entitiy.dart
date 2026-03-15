import 'package:equatable/equatable.dart';

class DailyProblemEntitiy extends Equatable {
  final String title;
  final String difficulty;
  final List<String> tags;
  final String problemUrl;
  final String problemId;
  final bool isLiked;
  final bool isDisliked;
  final bool isSolved;
  final int numberOfLikes;
  final int numberOfDislikes;
  final int numberOfSolvedPeople;

  const DailyProblemEntitiy({
    required this.title,
    required this.difficulty,
    required this.tags,
    required this.problemUrl,
    required this.problemId,
    required this.isLiked,
    required this.isDisliked,
    required this.isSolved,
    required this.numberOfLikes,
    required this.numberOfDislikes,
    required this.numberOfSolvedPeople,
  });

  @override
  List<Object?> get props => [
    title,
    difficulty,
    tags,
    problemUrl,
    problemId,
    isLiked,
    isDisliked,
    isSolved,
    numberOfLikes,
    numberOfDislikes,
    numberOfSolvedPeople,
  ];
}
