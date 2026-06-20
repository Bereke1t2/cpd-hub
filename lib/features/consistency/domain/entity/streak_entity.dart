import 'package:equatable/equatable.dart';

class StreakEntity extends Equatable {
  final int current;
  final int longest;

  /// Local date only (time stripped). Null means never solved anything.
  final DateTime? lastActiveDay;

  /// Freeze tokens that absorb a single missed day.
  final int freezesAvailable;

  /// Every local date the user solved at least one problem (last 168 days).
  final List<DateTime> activeDays;

  const StreakEntity({
    required this.current,
    required this.longest,
    required this.lastActiveDay,
    required this.freezesAvailable,
    required this.activeDays,
  });

  factory StreakEntity.empty() => const StreakEntity(
        current: 0,
        longest: 0,
        lastActiveDay: null,
        freezesAvailable: 2,
        activeDays: [],
      );

  StreakEntity copyWith({
    int? current,
    int? longest,
    DateTime? lastActiveDay,
    int? freezesAvailable,
    List<DateTime>? activeDays,
  }) =>
      StreakEntity(
        current: current ?? this.current,
        longest: longest ?? this.longest,
        lastActiveDay: lastActiveDay ?? this.lastActiveDay,
        freezesAvailable: freezesAvailable ?? this.freezesAvailable,
        activeDays: activeDays ?? this.activeDays,
      );

  /// How many of the last 7 days were active (0..1 for the week ring).
  double get weekRatio {
    final today = DateTime.now();
    int count = 0;
    for (int i = 0; i < 7; i++) {
      final d = DateTime(today.year, today.month, today.day - i);
      if (activeDays.any((a) => a.year == d.year && a.month == d.month && a.day == d.day)) {
        count++;
      }
    }
    return count / 7;
  }

  @override
  List<Object?> get props => [current, longest, lastActiveDay, freezesAvailable, activeDays];
}
