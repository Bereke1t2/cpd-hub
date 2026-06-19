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
  final String description;
  final int numberOfSolvedPeople;

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
    this.description = '',
    this.numberOfSolvedPeople = 0,
  });

  ProblemEntity copyWith({
    String? title,
    String? difficulty,
    List<String>? tags,
    int? numberOfLikes,
    int? numberOfDislikes,
    String? problemUrl,
    String? problemId,
    bool? isLiked,
    bool? isDisliked,
    bool? isSolved,
    String? description,
    int? numberOfSolvedPeople,
  }) => ProblemEntity(
    title: title ?? this.title,
    difficulty: difficulty ?? this.difficulty,
    tags: tags ?? this.tags,
    numberOfLikes: numberOfLikes ?? this.numberOfLikes,
    numberOfDislikes: numberOfDislikes ?? this.numberOfDislikes,
    problemUrl: problemUrl ?? this.problemUrl,
    problemId: problemId ?? this.problemId,
    isLiked: isLiked ?? this.isLiked,
    isDisliked: isDisliked ?? this.isDisliked,
    isSolved: isSolved ?? this.isSolved,
    description: description ?? this.description,
    numberOfSolvedPeople: numberOfSolvedPeople ?? this.numberOfSolvedPeople,
  );

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
        description,
        numberOfSolvedPeople,
      ];
}
