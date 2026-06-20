import 'package:equatable/equatable.dart';

/// The concept content attached to a topic (its "mini-course" material).
class LessonEntity extends Equatable {
  final String topicId;

  /// The main explanatory text shown on the topic detail page.
  final String body;

  /// 3–5 key takeaways shown as bullets below the body.
  final List<String> keyIdeas;

  const LessonEntity({
    required this.topicId,
    required this.body,
    required this.keyIdeas,
  });

  @override
  List<Object?> get props => [topicId, body, keyIdeas];
}
