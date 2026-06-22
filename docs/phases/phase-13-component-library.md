# Phase 13 — Component Library Unification

**Goal:** The app currently has **two design systems** living side by side — the old hand-rolled boxes
(`InfoBox`, `ProblemBox`, `ContestBox`, `UserBox`, `StreakProgressBox`, `TodaysProblemBox`, …) and the
newer `ui_kit` (`GradientCard`, `SectionHeader`, etc.). That inconsistency is most of the "ugly" feeling.
This phase collapses everything into **one** modern, dense, reusable component set built on the Phase 12
foundation, so every screen looks like it belongs to the same app.

**Depends on:** Phase 12 (tokens, responsive, `AppCard`).
**Risk:** Medium. Mechanical but wide. Migrate one component family at a time; keep the app compiling.

---

## Checklist
- [ ] 13.1 Promote `AppCard` (Phase 12 `perf_card.dart`) as the single surface; deprecate `GradientCard`.
- [ ] 13.2 Build the core kit on `AppDimens`: `AppText`, `AppChip`, `AppListTile`, `StatPill`, `SectionHeader`, `ProgressRing`, `Avatar`, `PrimaryButton`, `EmptyState`.
- [ ] 13.3 Rewrite legacy boxes as thin wrappers over the kit (same public params, new internals).
- [ ] 13.4 Difficulty / rating / status colors come from one helper (no inline `Color(0x..)`).
- [ ] 13.5 Delete dead duplicate widgets once their callers migrate.
- [ ] 13.6 A `widgetbook`/gallery screen (debug-only) showing every component at compact/medium/expanded.

## 13.1 One surface
`GradientCard` and every `Container(decoration: BoxDecoration(...))` card becomes `AppCard`. Search for
`BoxDecoration(` in `presentation/` — each hit is either a card (→ `AppCard`) or a chip/badge (→
`AppChip`). No feature widget should hand-roll a shadow/border/gradient again.

## 13.2 Core components (all read `AppDimens` + `context.r`)
| Component | Replaces | Notes |
|---|---|---|
| `AppCard` | `GradientCard`, raw `Container` cards | Phase 12 perf card |
| `AppText` | scattered `Text(style: TextStyle(fontSize:..))` | variants: hero/h1/h2/title/body/caption; scales via `context.r.sp` |
| `AppChip` | inline tag/badge `Container`s (tags, difficulty, division) | pill, 26px high |
| `AppListTile` | bespoke `Row`s in lists | leading/title/subtitle/trailing, overflow-safe |
| `StatPill` | keep (from ui_kit), restyle to `AppDimens` | label+value |
| `SectionHeader` | keep, restyle | title + optional trailing/icon |
| `ProgressRing` | keep, restyle | used by streak/topic/course progress |
| `Avatar` | `CircleAvatar(radius: 30)` in `user_box` | sizes from `AppDimens.avatar*` (18/22/32) |
| `PrimaryButton` | `normal_buttons` `width: 180`, raw `FilledButton`s | full-width by default, 46px high |
| `EmptyState` | the empty branch inside `AsyncView` | icon + message + optional action |

## 13.3 Legacy box migration (keep call sites working)
Rewrite each box's `build()` to compose the kit while keeping its constructor identical, so pages don't
change yet:
- `InfoBox` → `AppCard` + leading `AppChip(icon)` + `AppText.title/body`. Drop the 16px pad → `AppDimens.cardPadding`.
- `ProblemBox` / `problem_container` → `AppCard` + `AppText` + difficulty `AppChip`.
- `ContestBox` → `AppCard`; remove hardcoded `numberOfContestants` text when 0 (Phase 6.7 leftover).
- `UserBox` → `AppCard` + `Avatar(size: avatarMd)` (was radius 30) + rating `AppChip`.
- `TodaysProblemBox`, `StreakProgressBox`, `WelcomeBackBox`, `info_section`, `bar_box`, `tag_box`,
  `difficulty_box` → kit equivalents.

## 13.4 Semantic color helper
One `AppColors` helper: `difficulty(String)`, `rating(int)`, `topicStatus(...)`. Replace every inline
`Color(0xFF43A047)` / `Color(0xFFE53935)` in widgets with a call. Keeps difficulty/rating colors
identical everywhere (a11y: always pair color with a label/icon — already the rule in `01-ui-design-language.md`).

## 13.6 Component gallery (optional but recommended)
A debug-only `/_, gallery` route rendering each component in the three device classes. Lets the executing
model (and you) eyeball density/overflow without clicking through the whole app. Gate behind `kDebugMode`.

---

## Definition of Done
- [ ] No `presentation/` widget hand-rolls a card `BoxDecoration`; all use `AppCard`/`AppChip`.
- [ ] Legacy boxes still compile with unchanged constructors but render via the kit.
- [ ] Every font size flows through `AppText` (no raw `fontSize:` in feature widgets).
- [ ] `CircleAvatar(radius: 30)` and `width: 180`/`EdgeInsets.all(16)` magic numbers are gone.
- [ ] One screen (e.g. Home) visually matches the auth pages' density/polish.
