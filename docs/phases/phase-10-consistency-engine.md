# Phase 10 — Consistency Engine (Streaks · Goals · Ladders)

**Goal:** Make **consistency** a first-class citizen — the single biggest lever in competitive programming.
Turn the existing daily-problem + heatmap into a real engagement loop: a durable **streak**, weekly
**goals**, a rating-ordered daily **ladder** (structure + habit in one), and a **consistency leaderboard**
that adds social accountability inside the division.

**Depends on:** Phase 9 (ladders/goals reference the topic graph + problem mappings), Phase 5
(solve actions are the signal that advances a streak), Phase 7.B (notifications for reminders),
Phase 6 (`AsyncView`).
**Risk:** Medium. Mostly additive; the streak rules need care around timezones and "freezes".

> Pairs with Phase 9: structure tells you *what* to solve, consistency makes you *keep* solving. A ladder
> is the join of the two — an ordered queue you climb one problem a day.

---

## Checklist
- [ ] 10.1 `features/consistency/` module scaffolded.
- [ ] 10.2 Entities: `StreakEntity`, `GoalEntity`, `LadderEntity`, `LadderRungEntity`.
- [ ] 10.3 Streak engine (pure Dart): advance / break / freeze, timezone-safe day boundaries.
- [ ] 10.4 `StreakCubit` wired to the Phase-5 solve signal; persists locally + syncs when backend exists.
- [ ] 10.5 Goals: set weekly target (problems/topics), `GoalsBloc`, progress UI.
- [ ] 10.6 Ladders: rating-ordered problem queue, "today's rung", advance-on-solve.
- [ ] 10.7 Consistency leaderboard (reuse leaderboard UI; rank by streak / weekly solves).
- [ ] 10.8 Reminders: schedule a daily practice nudge (Phase 7.B), gated by a settings toggle.
- [ ] 10.9 Home "Consistency" hub: streak ring, today's ladder rung, weekly goal bar.
- [ ] 10.10 Real heatmap: feed `ProfilePage`'s contribution heatmap from solve history (kills the sine-wave mock).

---

## 10.1 Module layout
```
lib/features/consistency/
  data/
    datasources/ consistency_remote_data_source.dart (+ mock)
    models/ streak_model.dart, goal_model.dart, ladder_model.dart
    repository/ consistency_repository_impl.dart
  domain/
    entity/ streak_entity.dart, goal_entity.dart, ladder_entity.dart
    repository/ consistency_repository.dart
    service/ streak_engine.dart            # pure, unit-testable
    usecase/ get_streak.dart, get_goals.dart, set_goal.dart, get_ladder.dart
  presentation/
    bloc/ streak/ (cubit), goals/, ladder/
    page/ ladder_page.dart, consistency_page.dart
    widget/ streak_ring.dart, goal_bar.dart, ladder_rung_tile.dart, freeze_chip.dart
```

## 10.2 Entities
```dart
class StreakEntity extends Equatable {
  final int current;            // consecutive active days
  final int longest;
  final DateTime? lastActiveDay; // local date (date-only)
  final int freezesAvailable;   // "streak freeze" tokens
  final List<DateTime> activeDays; // for the mini-calendar / heatmap
}

class GoalEntity extends Equatable {
  final String id;
  final GoalType type;          // problemsPerWeek | topicsPerMonth | activeDaysPerWeek
  final int target;
  final int progress;           // current period
  final DateTime periodStart;
}

class LadderEntity extends Equatable {
  final String id;              // 'cf-1200-1400'
  final String title;           // 'Climb: 1200 → 1400'
  final int fromRating, toRating;
  final List<LadderRungEntity> rungs; // ordered, ascending difficulty
}

class LadderRungEntity extends Equatable {
  final String problemId;       // → existing ProblemEntity
  final int rating;
  final bool solved;
  final String? topicId;        // optional link into the Phase-9 graph
}
```

## 10.3 Streak engine (pure Dart)
Day boundaries are the whole game — get them right and test them:
```dart
class StreakEngine {
  /// Returns the new streak given the previous state and a solve on [day]
  /// (both normalized to the user's local date, time stripped).
  StreakEntity onSolve(StreakEntity prev, DateTime day);

  /// Called on app open / midnight rollover. If the user missed yesterday,
  /// consume a freeze if available, else reset current to 0.
  StreakEntity onDayRollover(StreakEntity prev, DateTime today);
}
```
Rules:
- Solve on the **same** day → no change to `current` (already counted).
- Solve on the **next** day → `current + 1`, update `longest`.
- Gap of **2+ days** → reset to 1 on next solve, unless a **freeze** covers the single missed day.
- Normalize to **local date** (strip time). Document the timezone assumption in the file header; never use
  raw UTC `DateTime.now()` for the boundary.

## 10.4 StreakCubit
- Listens to the Phase-5 "mark solved" success (shared signal / stream) → calls `engine.onSolve`.
- Runs `onDayRollover` on app resume.
- Persists with `shared_preferences` now; swap to backend (`GET/POST /streak`) when available, behind the
  same repository interface. No fabricated streak values shipped (kills the Phase-6 §6.7 `streak=7` hardcode).

## 10.5 Goals
- Default goal seeded on first run (e.g. "5 problems / week"); user-editable.
- `GoalsBloc` tracks progress for the current period; resets at `periodStart + period`.
- UI: a `GoalBar` (progress/target) on the consistency hub + an edit sheet.

## 10.6 Ladders — the killer feature
A ladder is an **ordered, rating-bucketed problem queue** (à la A2OJ). It removes "what do I solve today?"
friction *and* feeds the streak:
- Mock ladders by rating band (1000–1200, 1200–1400, …), each rung mapped to a real `problemId`.
- **"Today's rung"** = first unsolved rung. One tap opens it (Phase 7.D solve flow); solving advances the
  ladder and pings the streak.
- Show the ladder as a vertical climb with solved rungs filled; optional `topicId` chips link rungs back to
  the Phase-9 topic detail.
- Stretch: generate a personalized ladder from the user's rating ±200 and weak topics (lands fully in
  Phase 11).

## 10.7 Consistency leaderboard
Reuse `ContestLeaderboardPage`'s row/card widgets and `UsersBloc` data. Rank division members by
**current streak** (default) with a toggle for **problems this week**. Social pressure is the point —
seeing peers' streaks is a proven consistency driver.

## 10.8 Reminders
Build on Phase 7.B (`flutter_local_notifications`). If the user hasn't solved today by a configurable time
(default 8pm local), fire a "keep your N-day streak alive" nudge. Gate behind a Settings toggle (Phase 7.A).
Cancel the day's reminder once a solve lands.

## 10.9 Home consistency hub
A compact card on Home (and/or a dedicated `consistency_page.dart`):
- `StreakRing` (current streak, freezes left),
- today's ladder rung (one-tap start),
- weekly `GoalBar`.
This is the daily-return surface — keep it above the fold.

## 10.10 Real heatmap
`ProfilePage` already renders a contribution heatmap from a `Random(42)` sine wave. Replace its input with
`StreakEntity.activeDays` / solve history so it shows **real** activity. (The attendance heatmap is handled
separately by Phase 7.C.)

---

## Definition of Done
- [ ] Solving a problem advances the streak; missing a day resets it (or consumes a freeze) correctly.
- [ ] `StreakEngine` has unit tests: same-day, next-day, gap-reset, freeze-covers-gap, timezone boundary.
- [ ] Weekly goal is editable, tracks progress, and resets each period.
- [ ] A ladder shows "today's rung"; solving it advances the climb and the streak.
- [ ] Consistency leaderboard ranks the division by streak / weekly solves.
- [ ] Daily reminder fires only when needed and respects the settings toggle.
- [ ] Profile heatmap reflects real activity; the `streak=7` hardcode (Phase 6 §6.7) is gone.
