import 'package:equatable/equatable.dart';

/// A single watchable video attached to a lesson, rendered inline between
/// the concept text and the practice problems.
class LessonVideo extends Equatable {
  final String title;

  /// Direct streamable URL (mp4/HLS) played in-app via the video player.
  final String url;

  /// Optional human label like "6 min" shown on the poster.
  final String? durationLabel;

  const LessonVideo({
    required this.title,
    required this.url,
    this.durationLabel,
  });

  @override
  List<Object?> get props => [title, url, durationLabel];
}

/// The concept content attached to a topic (its "mini-course" material).
class LessonEntity extends Equatable {
  final String topicId;

  /// The main explanatory text shown on the topic detail page.
  final String body;

  /// 3–5 key takeaways shown as bullets below the body.
  final List<String> keyIdeas;

  /// Short videos the learner can watch inline. Empty when the topic has none.
  final List<LessonVideo> videos;

  const LessonEntity({
    required this.topicId,
    required this.body,
    required this.keyIdeas,
    this.videos = const [],
  });

  @override
  List<Object?> get props => [topicId, body, keyIdeas, videos];
}
