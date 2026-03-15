import 'package:equatable/equatable.dart';
import 'social_link_entity.dart';

class UserEntity extends Equatable {
  final String username;
  final String fullName;
  final String bio;
  final String avatarUrl;
  final int rating;
  final String rank;
  final String division;
  final int solvedProblems;
  final int contributions;
  final int globalRank;
  final int attendedContestsCount;
  final List<SocialLinkEntity> socialLinks;

  const UserEntity({
    required this.username,
    required this.fullName,
    required this.bio,
    required this.avatarUrl,
    required this.rating,
    required this.rank,
    required this.division,
    required this.solvedProblems,
    required this.contributions,
    required this.globalRank,
    required this.attendedContestsCount,
    required this.socialLinks,
  });

  @override
  List<Object?> get props => [
    username,
    fullName,
    bio,
    avatarUrl,
    rating,
    rank,
    division,
    solvedProblems,
    contributions,
    globalRank,
    attendedContestsCount,
    socialLinks,
  ];
}
