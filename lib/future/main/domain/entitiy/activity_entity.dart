import 'package:equatable/equatable.dart';

class ActivityEntity extends Equatable {
  final String id;
  final String username;
  final String action;
  final String type; // Solve, Rating, Badge
  final String timestamp;

  const ActivityEntity({
    required this.id,
    required this.username,
    required this.action,
    required this.type,
    required this.timestamp,
  });

  @override
  List<Object?> get props => [id, username, action, type, timestamp];
}
