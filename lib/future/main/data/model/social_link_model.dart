import '../../domain/entitiy/social_link_entity.dart';

class SocialLinkModel extends SocialLinkEntity {
  const SocialLinkModel({
    required super.platform,
    required super.url,
    required super.handle,
  });

  factory SocialLinkModel.fromJson(Map<String, dynamic> json) {
    return SocialLinkModel(
      platform: json['platform'] ?? '',
      url: json['url'] ?? '',
      handle: json['handle'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'platform': platform,
      'url': url,
      'handle': handle,
    };
  }
}
