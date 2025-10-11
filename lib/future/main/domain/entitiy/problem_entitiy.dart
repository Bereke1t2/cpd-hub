import 'package:equatable/equatable.dart';

class ProblemEntity extends Equatable {
  final String title;
  final String difficulty;
  final List<String> tags;
  final int numberOfLikes;
  final int numberOfDislikes;
  final String problemUrl;
  final String problemId;
  final bool isLiked;
  final bool isDisliked;
  final bool isSolved;

  const ProblemEntity({
    required this.title,
    required this.difficulty,
    required this.tags,
    required this.numberOfLikes,
    required this.numberOfDislikes,
    required this.problemUrl,
    required this.problemId,
    required this.isLiked,
    required this.isDisliked,
    required this.isSolved,
  });

  @override
  List<Object?> get props => [
        title,
        difficulty,
        tags,
        numberOfLikes,
        numberOfDislikes,
        problemUrl,
        problemId,
        isLiked,
        isDisliked,
        isSolved,
      ];
}