import 'package:lab_portal/future/main/domain/entitiy/user_entity.dart';

class UserModel extends UserEntity {
  const UserModel({
    required super.username,
    required super.fullName,
    required super.bio,
    required super.avatarUrl,
    required super.rating,
    required super.rank,
    required super.division,
    required super.solvedProblems,
    required super.contributions,
  }); 

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      username: json['username'] ?? '',
      fullName: json['fullName'] ?? '',
      bio: json['bio'] ?? '',
      avatarUrl: json['avatarUrl'] ?? '',
      rating: json['rating'] ?? 0,
      rank: json['rank'] ?? '',
      division: json['division'] ?? '',
      solvedProblems: json['solvedProblems'] ?? 0,
      contributions: json['contributions'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'fullName': fullName,
      'bio': bio,
      'avatarUrl': avatarUrl,
      'rating': rating,
      'rank': rank,
      'division': division,
      'solvedProblems': solvedProblems,
      'contributions': contributions,
    };
  }

}