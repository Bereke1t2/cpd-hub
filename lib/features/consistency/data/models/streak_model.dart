import '../../domain/entity/streak_entity.dart';

class StreakModel extends StreakEntity {
  const StreakModel({
    required super.current,
    required super.longest,
    required super.lastActiveDay,
    required super.freezesAvailable,
    required super.activeDays,
  });

  factory StreakModel.fromEntity(StreakEntity e) => StreakModel(
        current: e.current,
        longest: e.longest,
        lastActiveDay: e.lastActiveDay,
        freezesAvailable: e.freezesAvailable,
        activeDays: e.activeDays,
      );

  factory StreakModel.fromJson(Map<String, dynamic> j) => StreakModel(
        current: (j['current'] ?? 0) as int,
        longest: (j['longest'] ?? 0) as int,
        lastActiveDay: j['last_active_day'] != null
            ? DateTime.parse(j['last_active_day'] as String)
            : null,
        freezesAvailable: (j['freezes_available'] ?? 2) as int,
        activeDays: ((j['active_days'] as List?) ?? [])
            .map((s) => DateTime.parse(s as String))
            .toList(),
      );

  Map<String, dynamic> toJson() => {
        'current': current,
        'longest': longest,
        'last_active_day': lastActiveDay?.toIso8601String(),
        'freezes_available': freezesAvailable,
        'active_days': activeDays.map((d) => d.toIso8601String()).toList(),
      };
}
