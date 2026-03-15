import 'package:cpd_hub/future/main/data/model/social_link_model.dart';
import 'package:cpd_hub/future/main/domain/entitiy/user_entity.dart';

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
    required super.globalRank,
    required super.attendedContestsCount,
    required super.socialLinks,
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
      globalRank: json['globalRank'] ?? 0,
      attendedContestsCount: json['attendedContestsCount'] ?? 0,
      socialLinks:
          (json['socialLinks'] as List?)
              ?.map((e) => SocialLinkModel.fromJson(e))
              .toList() ??
          [],
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
      'globalRank': globalRank,
      'attendedContestsCount': attendedContestsCount,
      'socialLinks': socialLinks
          .map((e) => (e as SocialLinkModel).toJson())
          .toList(),
    };
  }
}
