// Pure Dart — no Flutter, no I/O, no DateTime.now().
// The caller passes "today" / "day" so results are deterministic and testable.
//
// TIMEZONE CONTRACT: all DateTimes passed in must already be LOCAL and
// time-stripped to midnight. Use StreakEngine.dayOf() at every call site.

import '../entity/streak_entity.dart';

class StreakEngine {
  const StreakEngine();

  /// Normalize any DateTime to a local date-only (midnight) value.
  /// Call this on every boundary input before handing it to the engine.
  static DateTime dayOf(DateTime dt) => DateTime(dt.year, dt.month, dt.day);

  int _gap(DateTime a, DateTime b) => dayOf(b).difference(dayOf(a)).inDays;

  // Prune activeDays to the most recent [keep] days to cap list growth.
  List<DateTime> _pruned(List<DateTime> days, DateTime today, {int keep = 168}) {
    final cutoff = dayOf(today).subtract(Duration(days: keep));
    return days.where((d) => !d.isBefore(cutoff)).toList();
  }

  /// Call every time a problem is solved. Idempotent for same-day solves.
  StreakEntity onSolve(StreakEntity prev, DateTime day) {
    final d = dayOf(day);
    final last = prev.lastActiveDay;

    // Deduplicate same-day solves.
    final alreadyActive = prev.activeDays
        .any((a) => a.year == d.year && a.month == d.month && a.day == d.day);
    final newActiveDays = alreadyActive
        ? prev.activeDays
        : _pruned([...prev.activeDays, d], d);

    if (last == null) {
      return prev.copyWith(
        current: 1,
        longest: prev.longest < 1 ? 1 : prev.longest,
        lastActiveDay: d,
        activeDays: newActiveDays,
      );
    }

    final gap = _gap(last, d);
    if (gap <= 0) {
      // Same day or earlier — streak unchanged, but record the day.
      return prev.copyWith(activeDays: newActiveDays);
    }

    int next;
    int freezes = prev.freezesAvailable;

    if (gap == 1) {
      next = prev.current + 1; // consecutive
    } else if (gap == 2 && prev.freezesAvailable > 0) {
      next = prev.current + 1; // one missed day, covered by a freeze
      freezes -= 1;
    } else {
      next = 1; // streak broke
    }

    return prev.copyWith(
      current: next,
      longest: next > prev.longest ? next : prev.longest,
      lastActiveDay: d,
      freezesAvailable: freezes,
      activeDays: newActiveDays,
    );
  }

  /// Call on app open / midnight rollover. Decays a stale streak.
  StreakEntity onDayRollover(StreakEntity prev, DateTime today) {
    final last = prev.lastActiveDay;
    if (last == null || prev.current == 0) return prev;

    final gap = _gap(last, today);
    if (gap <= 1) return prev; // still alive

    if (gap == 2 && prev.freezesAvailable > 0) {
      return prev.copyWith(freezesAvailable: prev.freezesAvailable - 1);
    }
    return prev.copyWith(current: 0);
  }
}
