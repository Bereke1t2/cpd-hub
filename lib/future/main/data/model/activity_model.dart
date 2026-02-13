import '../../domain/entitiy/activity_entity.dart';

class ActivityModel extends ActivityEntity {
  const ActivityModel({
    required super.id,
    required super.username,
    required super.action,
    required super.type,
    required super.timestamp,
  });

  factory ActivityModel.fromJson(Map<String, dynamic> json) {
    return ActivityModel(
      id: json['id'] ?? '',
      username: json['username'] ?? '',
      action: json['action'] ?? '',
      type: json['type'] ?? '',
      timestamp: json['timestamp'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'action': action,
      'type': type,
      'timestamp': timestamp,
    };
  }
}
