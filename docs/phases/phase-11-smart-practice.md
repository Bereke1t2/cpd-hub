# Phase 11 — Smart Practice (Personalization)

**Goal:** Use the data Phases 9–10 generate to make practice **personal**: detect per-topic strengths and
weaknesses, **recommend the next problem**, re-surface problems you struggled with via **spaced
repetition**, and track **upsolving** after contests. This is the "coach in your pocket" layer.

**Depends on:** Phase 9 (topic graph + problem→topic mapping), Phase 10 (solve history / streak signal),
Phase 5 (interactions), Phase 6 (`AsyncView`).
**Risk:** Medium. The logic is heuristic — keep it explainable and pure-Dart so it's tunable and testable.

> Everything here is derived analytics. It must degrade gracefully: with little history, fall back to the
> Phase-9 "available frontier" and Phase-10 ladder rather than inventing confident-looking recommendations.

> **Read [`../01-ui-design-language.md`](../01-ui-design-language.md) §6** (the "For You" spec). Reuse
> [`templates/ui_kit.dart`](../templates/ui_kit.dart) — `RecommendationCard` is a `GradientCard` with a
> mandatory `reason` line; the review queue uses `StatusChip`; strength on Profile reuses `GoalBar` rows or
> a radar. No new card styles.

---

## Checklist
- [ ] 11.1 `features/practice/` module scaffolded.
- [ ] 11.2 Entities: `TopicStrengthEntity`, `RecommendationEntity`, `ReviewItemEntity`, `UpsolveItemEntity`.
- [ ] 11.3 Strength analyzer (pure Dart): per-topic mastery from solve/attempt history.
- [ ] 11.4 Recommender: pick next problems (weak topic × right difficulty × prereqs satisfied).
- [ ] 11.5 Spaced-repetition review queue (struggled / failed problems resurface on a schedule).
- [ ] 11.6 Upsolving tracker: post-contest, list unsolved problems and nudge to finish them.
- [ ] 11.7 `PracticeBloc` + a "For You" page tying recommendations, review, and upsolve together.
- [ ] 11.8 Strength visualization on Profile (radar / per-category bars).

## 11.1 Module layout
```
lib/features/practice/
  data/  datasources (+ mock), models, repository
  domain/
    entity/ topic_strength_entity.dart, recommendation_entity.dart,
            review_item_entity.dart, upsolve_item_entity.dart
    service/ strength_analyzer.dart, recommender.dart, sm2_scheduler.dart  # pure
    usecase/ get_recommendations.dart, get_review_queue.dart, get_upsolves.dart
  presentation/
    bloc/ practice/
    page/ for_you_page.dart, review_page.dart, upsolve_page.dart
    widget/ recommendation_card.dart, strength_radar.dart, review_tile.dart
```

## 11.2 Entities
```dart
class TopicStrengthEntity extends Equatable {
  final String topicId;
  final double mastery;     // 0..1
  final int attempted, solved;
  final int avgTriesPerSolve;
}

class RecommendationEntity extends Equatable {
  final String problemId;
  final String topicId;
  final String reason;      // human-readable: "Weakest topic at your level"
  final int targetRating;
}

class ReviewItemEntity extends Equatable {
  final String problemId;
  final DateTime dueDate;   // next resurface date
  final int interval;       // days, SM-2 style
  final double ease;        // SM-2 ease factor
}

class UpsolveItemEntity extends Equatable {
  final String contestId;
  final String problemId;
  final bool resolved;      // solved after the contest
}
```

## 11.3 Strength analyzer (pure Dart)
```dart
class StrengthAnalyzer {
  List<TopicStrengthEntity> analyze(
    List<TopicEntity> topics,        // from Phase 9
    SolveHistory history,            // solves + attempt counts + timestamps
  );
}
```
Heuristic `mastery` per topic from: solved/total ratio, average tries per solved problem, and recency
(decay old solves). Keep it simple and **explainable** — every score must map to a sentence you can show
the user. Tune constants behind named fields, not magic numbers.

## 11.4 Recommender
```dart
class Recommender {
  List<RecommendationEntity> next(
    List<TopicStrengthEntity> strengths,
    Map<String, TopicProgress> graphProgress,  // Phase 9 engine output
    int userRating, {
    int count = 5,
  });
}
```
Selection: prefer the **weakest topic whose prerequisites are satisfied** (no recommending locked topics),
choose problems near the user's rating (±100–200), and avoid already-solved/already-queued problems. Each
result carries a `reason`. Fall back to the Phase-9 frontier when history is too thin to be confident.

## 11.5 Spaced repetition
When a problem is solved only after several tries — or explicitly flagged "review" — enqueue it with an
SM-2-style scheduler (`sm2_scheduler.dart`, pure + tested). It resurfaces on `dueDate`; a successful redo
lengthens the interval, a failure shortens it. This is Anki for problems — cements patterns instead of
solve-and-forget.

## 11.6 Upsolving tracker
After a contest (data already in `contests` + `contest_leaderboard`), list the problems the user **didn't**
solve as `UpsolveItemEntity`s. Surface them prominently ("3 problems to upsolve from Round 24"); mark
resolved when solved later. Upsolving is where real rating gains come from and no current surface nudges it.

## 11.7 "For You" page
One screen unifying: top recommendations (11.4), due reviews (11.5), and pending upsolves (11.6) — each a
section through `AsyncView`. This becomes the default practice destination once enough history exists.

## 11.8 Strength on Profile
Add a `strength_radar` (or per-category bars) to `ProfilePage` showing mastery across categories — the
honest "you're strong at graphs, weak at DP" picture that drives the recommender.

---

## Definition of Done
- [ ] Strength scores compute from history and each is explainable in one sentence.
- [ ] Recommendations never include locked-prereq or already-solved problems; each shows a reason.
- [ ] Review items resurface on schedule; redo success/failure adjusts the interval (SM-2 tested).
- [ ] Post-contest upsolve list is accurate and clears items when solved.
- [ ] "For You" page composes recommendations + reviews + upsolves via `AsyncView`.
- [ ] With near-empty history, the app falls back to Phase-9 frontier / Phase-10 ladder — no fabricated advice.
- [ ] `StrengthAnalyzer`, `Recommender`, `Sm2Scheduler` have unit tests.
