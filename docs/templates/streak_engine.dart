// lib/features/consistency/domain/service/streak_engine.dart
//
// Phase 10 — pure streak logic. NO DateTime.now() inside (the caller passes the
// "today"/"day" so it stays deterministic and testable — see Phase 10 DoD).
//
// TIMEZONE CONTRACT: all DateTimes passed in MUST be local, time-stripped to
// midnight. Use `StreakEngine.dayOf(DateTime)` at the call site to normalize.
// The streak is defined on *local calendar days*, never UTC instants.

import '../entity/streak_entity.dart';

class StreakEngine {
  const StreakEngine();

  /// Normalize any DateTime to a local date-only value. Call this on every
  /// boundary input (solve timestamp, "today") before handing it to the engine.
  static DateTime dayOf(DateTime dt) => DateTime(dt.year, dt.month, dt.day);

  int _daysBetween(DateTime a, DateTime b) => dayOf(b).difference(dayOf(a)).inDays;

  /// Apply a solve that happened on [day]. Idempotent for same-day solves.
  StreakEntity onSolve(StreakEntity prev, DateTime day) {
    final d = dayOf(day);
    final last = prev.lastActiveDay;

    if (last == null) {
      return prev.copyWith(
        current: 1,
        longest: prev.longest < 1 ? 1 : prev.longest,
        lastActiveDay: d,
        activeDays: {...prev.activeDays, d}.toList(),
      );
    }

    final gap = _daysBetween(last, d);
    if (gap <= 0) return prev; // same day (or earlier) — already counted

    int next;
    int freezes = prev.freezesAvailable;
    if (gap == 1) {
      next = prev.current + 1; // consecutive day
    } else if (gap == 2 && prev.freezesAvailable > 0) {
      next = prev.current + 1; // one missed day, covered by a freeze
      freezes -= 1;
    } else {
      next = 1; // streak broke; this solve starts a new one
    }

    return prev.copyWith(
      current: next,
      longest: next > prev.longest ? next : prev.longest,
      lastActiveDay: d,
      freezesAvailable: freezes,
      activeDays: {...prev.activeDays, d}.toList(),
    );
  }

  /// Called on app open / midnight rollover with no solve yet. Decays a stale
  /// streak: a single missed day consumes a freeze; a longer gap resets to 0.
  StreakEntity onDayRollover(StreakEntity prev, DateTime today) {
    final last = prev.lastActiveDay;
    if (last == null || prev.current == 0) return prev;

    final gap = _daysBetween(last, today);
    if (gap <= 1) return prev; // active today or yesterday — still alive

    if (gap == 2 && prev.freezesAvailable > 0) {
      // missed exactly one day; burn a freeze to keep the streak warm
      return prev.copyWith(freezesAvailable: prev.freezesAvailable - 1);
    }
    return prev.copyWith(current: 0); // broken
  }
}
