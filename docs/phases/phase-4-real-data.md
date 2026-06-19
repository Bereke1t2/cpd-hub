# Phase 4 — Real Data Integration

**Goal:** Flip the repository from mock to remote behind a single flag, wire the broken
Profile & Info features, and make `UsersPage`/`ProfilePage` use their BLoCs instead of faking data.

**Depends on:** Phase 2 (remote source), Phase 3 (auth/session for "my profile").
**Risk:** Medium. Behavior changes become visible. Keep the mock flag as an escape hatch.

---

## Checklist
- [ ] 4.1 Data-source selector flag (mock ↔ remote) in DI.
- [ ] 4.2 Route read methods in `MainRepoImpl` through the selected source.
- [ ] 4.3 Wire Profile (`getProfile`) end-to-end; build `ProfileBloc`.
- [ ] 4.4 Wire Info (`getInfo`).
- [ ] 4.5 Make `UsersPage` use `UsersBloc` (delete the `initState` random generator).
- [ ] 4.6 Make `ProfilePage` data-driven (current user, or a passed user).
- [ ] 4.7 Real `solvedProblems`/`contributions` (currently hardcoded 0 in mock + entity).

---

## 4.1 Source selector
In `core/config/app_config.dart` add:
```dart
static const bool useMock =
    bool.fromEnvironment('USE_MOCK', defaultValue: true);
```
In `injection.dart`, register the repo with the chosen sources. Simplest: keep `MainRepoImpl`'s current
constructor but have its read methods consult a single `DataSourceMode`. Cleaner: register either a
`MockMainRepo` or `RemoteMainRepo` based on `AppConfig.useMock`. Pick one; document it.

Run real data with:
```bash
flutter run --dart-define=USE_MOCK=false --dart-define=API_BASE_URL=https://staging…/api
```

## 4.2 Route reads through the source
Today `getProblems/getContests/getDailyProblems/getUsers/getContestLeaderboard` hit mock directly, while
`getProfile/getInfo` hit remote (and throw). Unify: each method calls the **selected** source. When
`useMock=false`, all reads go to `RemoteDataSourceImpl` (now implemented in Phase 2).

## 4.3 Profile feature
- Add `getContestLeaderboard`-style usecase `GetProfile` (exists) — make sure it's wired in DI.
- Create `ProfileBloc` (`Initial→Loading→Loaded(UserEntity)→Error`) — copy the `DailyProblemBloc` shape.
- `ProfilePage`: wrap in `BlocProvider(create: (_) => getIt<ProfileBloc>()..add(ProfileStarted()))`,
  replace the hardcoded "John Doe"/1520 block with `state.user` data. The heatmap/graph can keep
  generating visuals until the backend exposes history — but name/rating/division/stats come from data.

## 4.4 Info feature
`getInfo()` now works via remote. Surface it wherever the app shows announcements/info sections
(`InfoBox`). Add an `InfoBloc` or fold into an existing home bloc — keep it minimal.

## 4.5 Fix `UsersPage`
Currently a `StatefulWidget` that builds 24 random users in `initState` and filters with `setState`.
Replace with the existing `UsersBloc`:
```dart
BlocProvider(
  create: (_) => getIt<UsersBloc>()..add(const UsersStarted()),
  child: BlocBuilder<UsersBloc, UsersState>(builder: ...),
)
```
- Search field dispatches `UsersSearchChanged(query)`.
- Keep the responsive grid + rating-color system; just feed it `state.users`.
- The "View" button must pass the user to `UserDetailsPage` via the router (Phase 6 builds that page),
  not the global `/profile`.

## 4.6 `ProfilePage` data-driven
Two modes:
- **My profile** (from the Profile tab): uses `SessionBloc` user / `ProfileBloc`.
- **Other user** (tapped in `UsersPage`/leaderboard): receives a `UserEntity` (or id) as a route arg.

Make the page accept an optional `UserEntity? user`; if null, load the current user.

## 4.7 Real solved/contributions
Mock users hardcode `solvedProblems: 0` and `contributions: 0`. For the remote path these come from the
API. For the mock path (kept for offline dev), give them realistic non-zero values so the UI looks right.
Confirm the backend field names map through `UserModel.fromJson`.

---

## Definition of Done
- [ ] With `USE_MOCK=false`, Problems/Contests/Daily/Users/Profile/Info load from the backend.
- [ ] With `USE_MOCK=true` (default), the app still runs fully offline.
- [ ] `UsersPage` renders from `UsersBloc`; no `initState` data generation remains.
- [ ] `ProfilePage` shows the logged-in user by default and a tapped user when navigated with one.
- [ ] No `UnimplementedError` reachable from any read path.
