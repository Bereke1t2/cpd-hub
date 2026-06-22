# Phase 16 — Multi-Platform Contest Countdown

**Goal:** Show upcoming contests from **Codeforces, LeetCode, and other platforms** with a live
**countdown** to start time, plus platform filtering. The backend already aggregates these — the work is
mostly a polished, performant UI + a small amount of plumbing.

**Depends on:** Phase 12 (perf/responsive), Phase 13 (kit), Phase 4 (real-data layer).
**Risk:** Low-Medium. Backend data exists; the main pitfall is a naive 1-second timer repainting whole
lists.

> Backend already does the aggregation: `internal/infrastructure/external/kontests_client.go` fetches
> Codeforces (official API), LeetCode, and other platforms via kontests.net, and `GET /api/contests`
> returns merged `Contest` objects with `startTime`, `platform`, `isPast`, `numberOfContestants`, etc.
> The mobile `ContestModel` already parses these (Phase: backend wiring).

---

## Checklist
- [ ] 16.1 Add the `CountdownTimer` widget (see [`templates/countdown.dart`](../templates/countdown.dart)).
- [ ] 16.2 Parse `startTime` (ISO 8601 → local `DateTime`) once in the model; expose a typed `DateTime startsAt`.
- [ ] 16.3 Split the contests list into **Upcoming** (countdown) and **Past** (result link) sections.
- [ ] 16.4 Platform filter chips (All / Codeforces / LeetCode / AtCoder / …) driven by the distinct `platform` values returned.
- [ ] 16.5 Sort upcoming by soonest start; show a platform badge + the live countdown on each card.
- [ ] 16.6 "Starts in < 1h" emphasis (gold) and a one-shot `onElapsed` to flip the card to "Live now".
- [ ] 16.7 Home: a compact "Next contest" card showing the single soonest upcoming contest + countdown.
- [ ] 16.8 (Optional) Local reminder hook — schedule a notification N minutes before start (ties into Phase 7.B).

## Performance (the one real trap)
A `Timer.periodic(1s)` that calls `setState` on the contests page repaints the whole list every second.
Avoid it:
- The countdown ticking lives **only** inside `CountdownTimer` (its own `StatefulWidget` +
  `RepaintBoundary`) — see the template. The card and list never rebuild on tick.
- One timer per visible countdown is fine; off-screen cards aren't built (lazy `ListView`).
- Cancel the timer in `dispose()` (template does this) and fire `onElapsed` once.

## Data plumbing
- `ContestEntity` already has `startTime` (String), `platform`, `isPast`. Add a computed
  `DateTime get startsAt => DateTime.tryParse(startTime)?.toLocal() ?? DateTime.now();` (or parse in the
  model and store a real `DateTime`).
- Derive the filter list from `contests.map((c) => c.platform).toSet()` — no hardcoded platform list.
- Upcoming = `!isPast && startsAt.isAfter(now)`, sorted ascending by `startsAt`.

## UX
- `ContestCard` (Phase 13 `AppCard`): platform badge (`AppChip`), title, date, `CountdownTimer`, tap →
  leaderboard/standings (existing route).
- Filter row: `Wrap` of selectable `AppChip`s (overflow-safe, Phase 14 rule).
- Empty state via `AsyncView` ("No upcoming contests").

---

## Definition of Done
- [ ] Upcoming contests from ≥2 platforms show a live, ticking countdown.
- [ ] Ticking repaints only the timer text — list scroll stays ~60fps (verify with performance overlay).
- [ ] Platform filter chips reflect the real platforms returned and filter the list.
- [ ] A contest crossing its start time flips to "Live now" without a manual refresh.
- [ ] Home shows the single next upcoming contest with its countdown.
- [ ] No overflow at 360px; timers cancelled on dispose (no leaks).
