import '../../domain/entity/track_entity.dart';

class TrackModel extends TrackEntity {
  const TrackModel({
    required super.id,
    required super.title,
    required super.description,
    required super.topicIds,
    required super.iconName,
  });

  factory TrackModel.fromJson(Map<String, dynamic> j) => TrackModel(
        id: (j['id'] ?? '') as String,
        title: (j['title'] ?? '') as String,
        description: (j['description'] ?? '') as String,
        topicIds: List<String>.from(j['topic_ids'] ?? []),
        iconName: (j['icon_name'] ?? 'school') as String,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'description': description,
        'topic_ids': topicIds,
        'icon_name': iconName,
      };
}
