import 'package:equatable/equatable.dart';

class SocialLinkEntity extends Equatable {
  final String platform;
  final String url;
  final String handle;

  const SocialLinkEntity({
    required this.platform,
    required this.url,
    required this.handle,
  });

  @override
  List<Object?> get props => [platform, url, handle];
}
