# Phase 14 — Screen Redesign & Overflow Fixes

**Goal:** With the foundation (Phase 12) and component kit (Phase 13) in place, repaint each screen to a
modern, dense, responsive layout — and kill the overflows. Only **49** `Expanded`/`Flexible` exist across
all pages today, so many `Row`s overflow on narrow screens (the "some pages overflow" report).

**Depends on:** Phase 12, Phase 13.
**Risk:** Medium. Per-screen and visible. Do one screen per PR; screenshot before/after at 360px.

---

## Overflow rules (apply on every screen)
1. Any `Text` inside a `Row` gets wrapped in `Expanded`/`Flexible` + `maxLines` + `TextOverflow.ellipsis`.
2. Any horizontal group of chips uses `Wrap`, never a fixed `Row`.
3. Lists/grids switch column count via `context.r.gridColumns` (1 compact/medium, 3 expanded).
4. No fixed `height:`/`width:` on text-bearing containers — let content + padding size them.
5. Test every screen at **360 × 640** (small phone) and **1280** (web) before marking done.

---

## Checklist (one box per screen)
- [ ] 14.1 **Home** — biggest offender for "huge boxes". Tighten the stacked cards; the `InfoBox` blocks
      with long descriptions overflow vertically and read as oversized. Convert the "All Problems" inline
      container to a real section; cap the daily/streak/continue cards to the new density. Lazy sections
      (Phase 12.5).
- [ ] 14.2 **Problems** (`problems_page.dart`) — remove the hardcoded `~10m` (Phase 6.7 leftover, line ~337);
      responsive grid; overflow-safe problem cards.
- [ ] 14.3 **Profile** (`profile_page.dart`, **1134 lines** — the heaviest) — split into smaller widgets,
      isolate the heatmap + rating-graph `CustomPaint` (Phase 12.6), fix the wide/narrow column switch,
      shrink the oversized header.
- [ ] 14.4 **Contests** (`contest_page.dart`) — card list with countdown (lands fully in Phase 16);
      overflow-safe meta row.
- [ ] 14.5 **Contest Leaderboard** — dense table rows; the rank/name/score row must use `Expanded` for the
      name column only.
- [ ] 14.6 **Users** (`users_page.dart`) — responsive grid; `Avatar` not `radius:30`; isolate any charts.
- [ ] 14.7 **Problem Details** (`problem_details_page.dart`, 603 lines) — split, fix long-content overflow,
      wire the real "Solve" deep link (Phase 7.D) if not already.
- [ ] 14.8 **BasePage** — the gradient app bar + nav is heavy; flatten shadows, use `AppDimens.navBarHeight`,
      ensure the 6-tab bar doesn't overflow on compact (scrollable or icon-only labels < 360).

## Per-screen recipe
```dart
ResponsivePage(           // Phase 12.9 shell: max width + density padding
  child: CustomScrollView( // slivers for long pages (Profile, Details)
    slivers: [
      // sections built from AppCard / AppListTile / SectionHeader
    ],
  ),
)
```
- Replace `SingleChildScrollView + Column` on long pages (Home, Profile) with `CustomScrollView` +
  slivers so off-screen sections aren't built/laid-out eagerly.
- Each list/grid item is an `AppCard(isolate: true)`.

## Known concrete fixes to fold in
- Home `InfoBox` "Todays Contest" description is a wall of text → trim or move to a detail sheet.
- `ContestBox` `numberOfContestants` shows `0` → hide when unknown.
- `user_box` `CircleAvatar(radius: 30)` → `Avatar(size: AppDimens.avatarMd)`.
- `normal_buttons` `width: 180` → `PrimaryButton` (full-width / intrinsic).

---

## Definition of Done
- [ ] Every screen renders with **no RenderFlex overflow** at 360×640 (check the debug console — zero
      yellow/black stripes).
- [ ] Long pages use slivers; off-screen sections aren't built on first frame.
- [ ] Home/Problems/Profile/Contests/Users/Details/Leaderboard all match the kit density.
- [ ] Nav bar fits 6 tabs on a 360-wide screen.
- [ ] Before/after screenshots attached to each screen's PR.
