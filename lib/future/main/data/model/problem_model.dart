import '../../domain/entity/problem_entity.dart';

class ProblemModel extends ProblemEntity {
  const ProblemModel({
    required super.title,
    required super.difficulty,
    required super.tags,
    required super.numberOfLikes,
    required super.numberOfDislikes,
    required super.problemUrl,
    required super.problemId,
    required super.isLiked,
    required super.isDisliked,
    required super.isSolved,
  });

  factory ProblemModel.fromJson(Map<String, dynamic> json) {
    // Backend apiProblem() sends topicTags; fallback to tags/topic_tags.
    final rawTags = json['topicTags'] ?? json['tags'] ?? json['topic_tags'];
    return ProblemModel(
      title: (json['title'] ?? '') as String,
      difficulty: (json['difficulty'] ?? '') as String,
      tags: rawTags is List
          ? rawTags.whereType<String>().toList()
          : <String>[],
      numberOfLikes: (json['numberOfLikes'] ?? json['likes'] ?? 0) as int,
      numberOfDislikes: (json['numberOfDislikes'] ?? json['dislikes'] ?? 0) as int,
      problemUrl: (json['problemUrl'] ?? json['url'] ?? '') as String,
      problemId: (json['problemId'] ?? json['id'] ?? '') as String,
      isLiked: (json['isLiked'] ?? false) as bool,
      isDisliked: (json['isDisliked'] ?? false) as bool,
      // Backend sends "solved"; also accept "isSolved" for forward-compat.
      isSolved: (json['isSolved'] ?? json['solved'] ?? false) as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'difficulty': difficulty,
      'tags': tags,
      'numberOfLikes': numberOfLikes,
      'numberOfDislikes': numberOfDislikes,
      'problemUrl': problemUrl,
      'problemId': problemId,
      'isLiked': isLiked,
      'isDisliked': isDisliked,
      'isSolved': isSolved,
    };
  }
}