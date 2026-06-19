# Phase 6 — UI / UX Polish & Fixes

**Goal:** Standardize async states, fill navigation dead-ends, add theming + accessibility, and apply the
design tokens. This is the "make it feel finished" phase.

**Depends on:** Phase 1 (tokens/router), Phase 4 (real data). Can run alongside Phase 5.
**Risk:** Low-Medium. Lots of small, visible changes.

---

## Checklist
- [ ] 6.1 Shared `AsyncView<T>` widget (loading / error+retry / empty / data).
- [ ] 6.2 Adopt it across all BLoC pages; add retry buttons everywhere.
- [ ] 6.3 Build the empty `UserDetailsPage`.
- [ ] 6.4 Make leaderboard rows + user cards tappable → user details.
- [ ] 6.5 Theme: `AppTheme` + light/dark toggle (persisted).
- [ ] 6.6 Accessibility: semantic labels, tooltips, text-with-color difficulty.
- [ ] 6.7 Replace hardcoded UI values (time "~10m", contestants=1, magic icon `0xe0cc`).
- [ ] 6.8 Apply design tokens (spacing/radii/text) to high-traffic widgets.
- [ ] 6.9 Prevent duplicate tab navigation in `BasePage`.

---

## 6.1 `AsyncView`
A single widget that renders the four BLoC states consistently. See
[`templates/async_view.dart`](../templates/async_view.dart). Usage:
```dart
BlocBuilder<ProblemsBloc, ProblemsState>(
  builder: (context, state) => AsyncView<List<ProblemEntity>>(
    isLoading: state is ProblemsLoading,
    error: state is ProblemsError ? state.message : null,
    data: state is ProblemsLoaded ? state.problems : null,
    isEmpty: (d) => d.isEmpty,
    onRetry: () => context.read<ProblemsBloc>().add(const ProblemsStarted()),
    emptyMessage: 'No problems found',
    builder: (problems) => ProblemsGrid(problems),
  ),
)
```

## 6.2 Adopt everywhere + retry
Every list/detail page routes its state through `AsyncView`. Error states get a **Retry** button (today
they only show text). Covers: Problems, Contests, Users, Daily, Leaderboard, Profile.

## 6.3 `UserDetailsPage`
It's currently ~1 line. Build it to show a single user's profile (reuse `ProfilePage` sections or a
lighter layout). It receives a `UserEntity` (or id) via the router. This is the destination for taps from
`UsersPage` and leaderboard rows.

## 6.4 Tappable rows
- `UserBox` / users grid cards → `Navigator.pushNamed(context, RouteNames.userDetails, arguments: user)`.
- Leaderboard entries (`ContestLeaderboardPage`) → same, by username/id.
Remove the hardcoded `/profile` jump for other users.

## 6.5 Theming
Create `core/theme/app_theme.dart` with `AppTheme.dark` and `AppTheme.light` built from `UiConstants`.
Add a `ThemeCubit` (persists choice in `shared_preferences`) and a toggle in Settings (Phase 7) or the
profile header. `MaterialApp` uses `themeMode` from the cubit.

> The app is currently dark-only with `Color(0xFF121212)` etc. Light theme can come later, but wire the
> mechanism now so the toggle exists.

## 6.6 Accessibility
- Wrap icon-only buttons in `Tooltip` / add `Semantics(label: …)`.
- The bottom-nav Problems icon uses magic `IconData(0xe0cc)` — replace with a named `Icons.*` constant.
- Difficulty is color-only — keep the colored badge but ensure the letter/word (E/M/H) is always present
  for color-blind users (the `DifficultyBox` already shows text; verify everywhere).

## 6.7 Kill hardcoded UI values
| Location | Now | Fix |
|----------|-----|-----|
| `ProblemsPage` | time "~10m" for all | derive from data or remove |
| `ContestPage` | `numberOfContestants = 1` | use real count or hide until available |
| `StreakProgressBox` | streak=7, 42/100 | feed from profile/session data |
| `BasePage` | `IconData(0xe0cc)` | named icon |

## 6.8 Apply tokens
Sweep the most-used widgets (`ProblemBox`, `ContestBox`, `UserBox`, `InfoBox`, cards in pages) to use
`AppSpacing`/`AppRadii`/`AppTextStyles` and `UiConstants.cardShadow`/`cardBorder`. Boy-scout rule — don't
attempt all 25 widgets in one PR; do them in small reviewable batches.

## 6.9 Tab nav guard
In `BasePage.onTap`, skip navigation when the tapped index == current index to avoid re-pushing the route.

---

## Definition of Done
- [ ] Every async page shows consistent loading / empty / error-with-retry states.
- [ ] `UserDetailsPage` works; user taps from lists and leaderboards reach it.
- [ ] Theme toggle persists across restarts.
- [ ] No magic icon codes; icon buttons have tooltips/semantics.
- [ ] The hardcoded UI values in §6.7 are gone or data-driven.
