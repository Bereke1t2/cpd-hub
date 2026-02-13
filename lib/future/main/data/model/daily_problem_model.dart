import 'package:cpd_hub/future/main/domain/entitiy/daily_problem_entitiy.dart';

class DailyProblemModel extends DailyProblemEntitiy {
  const DailyProblemModel({
    required super.title,
    required super.difficulty,
    required super.tags,
    required super.problemUrl,
    required super.problemId,
    required super.isLiked,
    required super.isDisliked,
    required super.isSolved,
    required super.numberOfLikes,
    required super.numberOfDislikes,
    required super.numberOfSolvedPeople,
  });

  factory DailyProblemModel.fromJson(Map<String, dynamic> json) {
    return DailyProblemModel(
      title: json['title'] as String? ?? '',
      difficulty: json['difficulty'] as String? ?? '',
      tags: (json['tags'] as List? ?? const [])
          .map((e) => e.toString())
          .toList(growable: false),
      problemUrl: json['problemUrl'] as String? ?? '',
      problemId: json['problemId'] as String? ?? '',
      isLiked: json['isLiked'] as bool? ?? false,
      isDisliked: json['isDisliked'] as bool? ?? false,
      isSolved: json['isSolved'] as bool? ?? false,
      numberOfLikes: (json['numberOfLikes'] as num?)?.toInt() ?? 0,
      numberOfDislikes: (json['numberOfDislikes'] as num?)?.toInt() ?? 0,
      numberOfSolvedPeople: (json['numberOfSolvedPeople'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
        'title': title,
        'difficulty': difficulty,
        'tags': tags,
        'problemUrl': problemUrl,
        'problemId': problemId,
        'isLiked': isLiked,
        'isDisliked': isDisliked,
        'isSolved': isSolved,
        'numberOfLikes': numberOfLikes,
        'numberOfDislikes': numberOfDislikes,
        'numberOfSolvedPeople': numberOfSolvedPeople,
      };

  DailyProblemModel copyWith({
    String? title,
    String? difficulty,
    List<String>? tags,
    String? problemUrl,
    String? problemId,
    bool? isLiked,
    bool? isDisliked,
    bool? isSolved,
    int? numberOfLikes,
    int? numberOfDislikes,
    int? numberOfSolvedPeople,
  }) {
    return DailyProblemModel(
      title: title ?? this.title,
      difficulty: difficulty ?? this.difficulty,
      tags: tags ?? this.tags,
      problemUrl: problemUrl ?? this.problemUrl,
      problemId: problemId ?? this.problemId,
      isLiked: isLiked ?? this.isLiked,
      isDisliked: isDisliked ?? this.isDisliked,
      isSolved: isSolved ?? this.isSolved,
      numberOfLikes: numberOfLikes ?? this.numberOfLikes,
      numberOfDislikes: numberOfDislikes ?? this.numberOfDislikes,
      numberOfSolvedPeople: numberOfSolvedPeople ?? this.numberOfSolvedPeople,
    );
  }
}