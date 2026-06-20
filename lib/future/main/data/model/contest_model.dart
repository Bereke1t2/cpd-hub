import '../../domain/entity/contest_entity.dart';

class ContestModel extends ContestEntity {
  const ContestModel({
    required super.id,
    required super.title,
    required super.contestUrl,
    required super.startTime,
    required super.duration,
    required super.platform,
    required super.numberOfProblems,
    required super.isPast,
    required super.isParticipating,
  });

  factory ContestModel.fromJson(Map<String, dynamic> json) {
    // startTime from Go is time.Time → ISO 8601 string on the wire.
    final rawStart = json['startTime'];
    final startTime = rawStart is String
        ? rawStart
        : (rawStart?.toString() ?? '');
    return ContestModel(
      id: (json['id'] ?? '') as String,
      title: (json['title'] ?? '') as String,
      contestUrl: (json['contestUrl'] ?? '') as String,
      startTime: startTime,
      duration: (json['duration'] ?? '') as String,
      platform: (json['platform'] ?? '') as String,
      numberOfProblems: (json['numberOfProblems'] ?? 0) as int,
      isPast: (json['isPast'] ?? false) as bool,
      isParticipating: (json['isParticipating'] ?? false) as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'contestUrl': contestUrl,
      'startTime': startTime,
      'duration': duration,
      'platform': platform,
      'numberOfProblems': numberOfProblems,
      'isPast': isPast,
      'isParticipating': isParticipating,
    };
  }
}