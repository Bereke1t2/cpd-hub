# Phase 7 — New Features

**Goal:** Add the capabilities the README promises but the app lacks: notifications/event reminders,
settings, attendance tracking, submission flow, and deep-linkable detail screens.

**Depends on:** Phase 5 (interactions), Phase 6 (UI shell, router, theme).
**Risk:** Medium. New surface area; ship features one at a time behind the existing architecture.

Each feature below is a **self-contained mini-phase**. Build them in priority order; none blocks another.

---

## 7.A Settings
**Why:** Home for theme toggle, account, notifications prefs, logout, about.
- New `features/settings/presentation/page/settings_page.dart`, route `RouteNames.settings`.
- Sections: Appearance (theme toggle → `ThemeCubit`), Notifications (toggles → prefs), Account
  (edit profile, change password, **Logout** → `SessionBloc.LoggedOut`), About (version from package_info).
- Reachable from the profile header gear icon.
- Persist prefs with `shared_preferences`.

## 7.B Event reminders / notifications
**Why:** README headline feature ("get notified about upcoming contests").
- Add `flutter_local_notifications` (+ `timezone`).
- `core/notifications/notification_service.dart`: init, request permission, `scheduleContestReminder`.
- When contests load, schedule a local notification N minutes before `startTime` for contests the user is
  participating in. Cancel on un-participation.
- Settings toggle gates scheduling. Document the iOS/Android permission setup in the file header.
- Push (FCM) is a later add-on; local reminders cover the core need first.

## 7.C Attendance tracking
**Why:** README lists attendance for 30+ members; `ProfilePage` already has an attendance heatmap (mocked).
- `features/attendance/`: entity (date, present/absent/status), data source, repo, bloc.
- Endpoint: `GET /attendance/{userId}` and (for admins) `POST /attendance`.
- Feed the existing attendance heatmap on `ProfilePage` with real data (replace the sine-wave mock).
- Optional admin role: a check-in screen to mark members present at a session.

## 7.D Submission / "Solve" flow
**Why:** "Solve Problem" button is a no-op.
- Minimum viable: open the problem's `problemUrl` in an external browser (`url_launcher`) and offer
  "Mark as solved" (Phase 5 action) on return.
- Later: in-app submission against the backend judge if/when that API exists.
- Add submission history to `ProblemDetailsPage` (list of attempts) once an endpoint exists; until then,
  hide the section rather than showing placeholder text.

## 7.E Deep-linkable details
**Why:** Router exists (Phase 1) but details aren't parameterized URLs.
- Give `problem`, `user`, `contestLeaderboard` routes real path params so web links work
  (`/#/problem/123`). The app already targets web (`web/` exists).
- Useful for sharing a problem/leaderboard link in the community.

## 7.F Real performance insights
**Why:** `RatingGraph` on profile is currently synthetic.
- `GET /users/{id}/rating-history` → feed the graph.
- Replace the procedurally-generated 12-point series with real contest deltas
  (the leaderboard already carries `oldRating`/`newRating`).

---

## Priorities
1. **7.A Settings** + **7.B Reminders** — highest user value, small surface.
2. **7.D Solve flow** — closes an obvious dead button.
3. **7.C Attendance** + **7.F Insights** — depend on backend endpoints; sequence with the API team.
4. **7.E Deep links** — polish.

---

## Definition of Done (per feature)
- [ ] Feature module follows the data/domain/presentation split.
- [ ] State via a BLoC/Cubit through `AsyncView`.
- [ ] No placeholder/hardcoded data shipped; if an endpoint is missing, the section is hidden, not faked.
- [ ] Added to the router + navigable.
- [ ] Smoke-tested on web + one mobile target.
