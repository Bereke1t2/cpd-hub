# Phase 12 — UI Foundation & Performance

**Goal:** Fix the three things that make the app feel "ugly and laggy": (1) everything is oversized and
disproportional, (2) scrolling janks, (3) no responsive scaling so small phones (the itel A667L test
device) look cramped while web looks stretched. This phase lays the *foundation* — tokens, density,
responsiveness, and the performance fixes — so Phases 13–14 can repaint every screen on a solid base.

**Depends on:** Phase 0 (tokens), Phase 6 (`AsyncView`). Supersedes the loose sizing in Phase 0's
`AppSpacing`/`AppRadii` by tightening the scale.
**Risk:** Medium. Touches shared widgets used everywhere — do it in small, compiling steps and visually
diff each screen.

> The auth (login/signup) pages are the only screens that already look right. Treat their density,
> spacing, and typography as the **reference** for the rest of the app.

---

## Audit — concrete problems found

| Symptom | Root cause | Evidence |
|---|---|---|
| Everything looks huge | `EdgeInsets.all(16)` is the de-facto default on every box; `radius: 30` avatars; body text at `fontSize: 16–24` | `info_box`, `contest_box`, `problem_box`, `welcomback_box`, `user_box` all use 16px pad; `user_box.dart:107 radius: 30` |
| Scroll jank / lag | `GradientCard` wraps **every** child in `Opacity()` even at 1.0 → forces `saveLayer` composite per card per frame | `ui_kit.dart:48` |
| Constant allocations | 138 `withOpacity()` calls rebuild Color objects each frame | repo-wide grep |
| Home stutters on open | HomePage starts **5 BlocProviders at once** (DailyProblem, Problems, Topics, Streak, Goals) → 5 concurrent loads + path-engine run on first frame | `home_page.dart:40–48` |
| Charts re-paint siblings | `CustomPaint` heatmap / rating graph / user charts not wrapped in `RepaintBoundary` | `profile_page.dart`, `users_page.dart` |
| Cramped on small screens | fixed px, no `MediaQuery`/density scaling anywhere meaningful | only 38 responsive refs across all widgets |

---

## Checklist
- [ ] 12.1 Add `app_dimens.dart` (tightened spacing/radius/size scale).
- [ ] 12.2 Add `responsive.dart` (`context.r`, device classes, `sp()`/`dp()`/`gap`).
- [ ] 12.3 Tighten `AppTextStyles` to the new type scale (body 13, titles 14, hero 22).
- [ ] 12.4 Kill the always-on `Opacity` in the card primitive (ship `AppCard`, see Phase 13).
- [ ] 12.5 Lazy-load Home: don't fire all 5 BlocProviders eagerly.
- [ ] 12.6 Wrap every `CustomPaint` (heatmap, rating graph, user charts) in `RepaintBoundary`.
- [ ] 12.7 Migrate `withOpacity` → `withValues(alpha:)` in shared widgets (kills deprecation + precision warnings).
- [ ] 12.8 `const`-ify static widgets; add `RepaintBoundary` to list/grid items.
- [ ] 12.9 Establish the responsive page shell (max content width, density padding).

## 12.1 / 12.2 Tokens + responsiveness
Copy [`templates/app_dimens.dart`](../templates/app_dimens.dart) → `lib/core/theme/app_dimens.dart` and
[`templates/responsive.dart`](../templates/responsive.dart) → `lib/core/theme/responsive.dart`.

The new scale is **deliberately denser**: base padding 12 (not 16), radius caps at 18 (not 30), body
text 13. This single change removes most of the "oversized" feel.

## 12.3 Typography
Rewrite `AppTextStyles` to the `AppDimens.f*` sizes. Sizes that must adapt per device read through
`context.r.sp(...)` at the call site (the static `TextStyle` keeps the base size). Cap OS text scaling
via `Responsive` so accessibility settings can't overflow dense cards.

## 12.4 The card primitive (perf-critical)
The biggest single lag fix. See [`templates/perf_card.dart`](../templates/perf_card.dart) — `Opacity`
is inserted **only when `dimmed`**, and list items can opt into `isolate: true` (RepaintBoundary).
Phase 13 swaps all `GradientCard`/legacy boxes to this.

## 12.5 Lazy Home providers
Don't construct + `add()` all five blocs in the page's `MultiBlocProvider`. Options:
- Provide the cheap/session ones eagerly (Streak, Goals are singletons already).
- Defer `Topics` (runs the path engine) and `Problems` until their section scrolls into view, or
  trigger them in a post-frame callback instead of synchronously during the first build.
- Never run the path engine on the Home thread during the first frame.

## 12.6 / 12.8 Isolate paints
Wrap `ContributionHeatMap`, `RatingGraph`, and the users-page charts in `RepaintBoundary`. Confirm
`shouldRepaint` returns `false` when inputs are unchanged (it does today — keep it). Add
`RepaintBoundary` to `ListView`/`GridView` item builders for problems, users, leaderboard.

## 12.7 Opacity API
Mechanical sweep in shared widgets: `color.withOpacity(x)` → `color.withValues(alpha: x)`. Do shared
widgets first (highest call count), feature pages during their Phase-14 redesign.

## 12.9 Responsive page shell
A `ResponsivePage` wrapper (or extend `BasePage`) that centers content at `r.contentMaxWidth` on wide
screens and applies `AppDimens.pagePadding`. Every page body sits inside it.

---

## Definition of Done
- [ ] `flutter run` on a 360-wide device: no oversized boxes; spacing matches the auth pages.
- [ ] Scrolling Problems/Users lists holds ~60fps (check with the performance overlay / DevTools).
- [ ] Home opens without a visible hitch; the path engine never blocks the first frame.
- [ ] All `CustomPaint` widgets and list items are `RepaintBoundary`-isolated.
- [ ] `app_dimens.dart` + `responsive.dart` exist and are exported; new code uses them.
- [ ] No `withOpacity` deprecation infos in shared widgets.
