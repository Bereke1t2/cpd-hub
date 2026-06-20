import 'package:equatable/equatable.dart';

/// A curated, ordered sequence of topics that forms a goal-oriented learning path.
class TrackEntity extends Equatable {
  final String id;
  final String title;
  final String description;

  /// Ordered list of topic ids — first to last.
  final List<String> topicIds;

  /// Material icon name key (e.g. 'trophy', 'bolt').
  final String iconName;

  const TrackEntity({
    required this.id,
    required this.title,
    required this.description,
    required this.topicIds,
    required this.iconName,
  });

  @override
  List<Object?> get props => [id, title, description, topicIds, iconName];
}
