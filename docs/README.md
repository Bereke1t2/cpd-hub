# CPD_HUB — Execution Plan & Engineering Playbook

> Competitive Programming Division management app. Flutter (this repo) + Django REST backend.
> Package name: `lab_portal`. Architecture: Clean Architecture (data / domain / presentation) with `flutter_bloc` + `dartz`.

This folder is the **single source of truth** for evolving CPD_HUB from a mock-data prototype into a
production app. It is split into **phases**. Each phase is a self-contained "skill" file with a goal,
checklist, step-by-step instructions, and copy-paste code templates.

Work the phases **in order** — each one assumes the previous is merged. Inside a phase, tasks are
ordered so the app keeps compiling after every step.

---

## 1. Where the project is today (audit summary)

| Area | State | Notes |
|------|-------|-------|
| Architecture | ✅ Solid | Clean layering: `data → domain → presentation`, `Either<T, Failure>` everywhere. |
| Mock data | ✅ Works | Problems, Daily Problem, Contests, Leaderboard, Users served from `mock/`. |
| `RemoteDataSource` | ❌ Stub | All 10 methods `throw UnimplementedError()`. No HTTP client in pubspec. |
| Auth | ❌ Missing | No login, no token storage, user identity hardcoded (`"Bereket"`). |
| Profile / Info | ❌ Broken | Route through remote layer → throws. No mock fallback. |
| Write actions | ❌ No-op | like / dislike / mark-solved buttons have empty `onPressed`. |
| `UsersPage` | ⚠️ Bypasses BLoC | Generates 24 random users in `initState()`; `UsersBloc` exists but unused. |
| `ProfilePage` | ⚠️ Hardcoded | "John Doe", static heatmap/graph; not wired to any data source. |
| `UserDetailsPage` | ⚠️ Empty | One line; all user taps route to the global `/profile`. |
| `MainBloc` | ⚠️ Dead code | Handler is a TODO; never provided. Decide: finish or delete. |
| Navigation | ⚠️ Mixed | Named routes for tabs; `MaterialPageRoute` for details; no params (`/user/:id`). |
| Design system | ⚠️ Inconsistent | Magic colors, 6+ border radii, no spacing/typography scale. |
| DI | ⚠️ Manual | `MainDI.buildX()` builds a fresh repo per call → duplicate data sources. |
| Tests | ⚠️ Default only | Only the generated `widget_test.dart`. |

**One-line takeaway:** the skeleton is good; the work is (a) make the remote layer real, (b) add auth,
(c) connect the UI pages that currently fake their data, and (d) standardize the design system.

---

## 2. Target architecture

```
lib/
  core/
    config/        env + flavor config           (NEW)
    di/            get_it service locator         (NEW, replaces ad-hoc MainDI)
    network/       Dio client, interceptors       (NEW)
    routing/       central router + route names   (NEW)
    theme/         UiConstants + AppSpacing/Radii/TextStyles  (EXTENDED)
    error/         failure.dart (exists), exceptions.dart (NEW)
    storage/       secure token store             (NEW)
  features/
    auth/          login/register/session         (NEW feature module)
    main/          existing feature (kept)
      data / domain / presentation
```

Principles we keep:
- **`Either<T, Failure>` for every repository call.** (Note: this repo puts success on `Left`.)
- **One BLoC per screen concern.** Pages never fake their own data.
- **Models extend Entities** and own `fromJson` / `toJson`.
- **Data sources are swappable** (mock ↔ remote) behind an interface.

New rules we add:
- **`get_it` singletons** so we don't rebuild the repo per page.
- **Central router** with typed route names + arguments.
- **No magic numbers** in widgets — pull from the design-system tokens.

---

## 3. Phase roadmap

| Phase | File | Goal | Depends on |
|-------|------|------|-----------|
| 0 | [`00-conventions-and-design-system.md`](./00-conventions-and-design-system.md) | Tokens, naming, the `Either`-on-Left gotcha, DI/router conventions | — |
| 0b | [`01-ui-design-language.md`](./01-ui-design-language.md) | How to compose tokens into a consistent modern look + per-screen specs for phases 9–11 | 0 |
| 1 | [`phases/phase-1-foundation.md`](./phases/phase-1-foundation.md) | Cleanup, design-system tokens, `get_it`, central router, fix `info_entitity` typo, remove dead `MainBloc` | 0 |
| 2 | [`phases/phase-2-networking.md`](./phases/phase-2-networking.md) | Dio client, env config, exceptions, real `RemoteDataSource` (read endpoints) | 1 |
| 3 | [`phases/phase-3-auth.md`](./phases/phase-3-auth.md) | Auth feature: login/register, secure token storage, auth gate, session BLoC | 1, 2 |
| 4 | [`phases/phase-4-real-data.md`](./phases/phase-4-real-data.md) | Flip repo from mock→remote behind a flag; wire Profile & Info; real Users via `UsersBloc` | 2, 3 |
| 5 | [`phases/phase-5-interactions.md`](./phases/phase-5-interactions.md) | Make like / dislike / mark-solved real with optimistic UI; bookmarks | 4 |
| 6 | [`phases/phase-6-ui-ux.md`](./phases/phase-6-ui-ux.md) | Async-state widget, retry/empty states, `UserDetailsPage`, theme toggle, a11y, search-clear fix | 1, 4 |
| 7 | [`phases/phase-7-new-features.md`](./phases/phase-7-new-features.md) | Notifications, settings, attendance, submission flow, deep-linkable details | 5, 6 |
| 8 | [`phases/phase-8-testing-release.md`](./phases/phase-8-testing-release.md) | Unit/bloc/widget tests, CI, flavors, release checklist | all |

### CP-specific learning track (phases 9–11)

These extend the app from a problem browser into a learning platform tailored to competitive programmers.
They build on the production foundation above and can be sequenced after Phase 6.

| Phase | File | Goal | Depends on |
|-------|------|------|-----------|
| 9 | [`phases/phase-9-structured-learning.md`](./phases/phase-9-structured-learning.md) | Topic dependency graph (DAG), skill tree, "what to learn next/before", topic mini-courses + Tracks | 4, 6 |
| 10 | [`phases/phase-10-consistency-engine.md`](./phases/phase-10-consistency-engine.md) | First-class streaks, weekly goals, rating-ordered ladders, consistency leaderboard, reminders | 9, 5, 7.B |
| 11 | [`phases/phase-11-smart-practice.md`](./phases/phase-11-smart-practice.md) | Per-topic strength analysis, next-problem recommender, spaced-repetition review, upsolving tracker | 9, 10, 5 |

Build **9 before 10 before 11** — the topic graph is the backbone ladders, goals, and recommendations all
reference. Each ships mock-first behind the existing data-source interface, like every prior phase.

Phases 5 and 6 can run in parallel once 4 is merged. Phase 3 can start as soon as the Dio client (Phase 2) exists.

---

## 4. How to use these docs

1. Open the phase file. Read **Goal** and **Definition of Done**.
2. Copy templates from [`templates/`](./templates/) referenced in each step.
3. Work the checklist top-to-bottom; keep `flutter analyze` clean after each step.
4. Tick the Definition of Done before moving on.

### Standing commands
```bash
flutter pub get          # after any pubspec change
flutter analyze          # must stay clean
flutter test             # green before merge
dart format lib test     # before commit
flutter run -d chrome    # quick smoke test (web target exists)
```

---

## 5. Conventions quick links
- Design tokens & the `Left = success` gotcha → [`00-conventions-and-design-system.md`](./00-conventions-and-design-system.md)
- Reusable code → [`templates/`](./templates/)

---

## 6. Risk notes
- **`Either` orientation is inverted** vs. dartz convention (success on `Left`). Keep it consistent or
  refactor deliberately in one PR — do not mix. See Phase 1.
- **Backend contract** (Django REST) must be pinned before Phase 2 endpoints — confirm JSON field names
  against the `fromJson` parsers (the models already tolerate some variation).
- **Secrets**: never commit real base URLs / keys. Use `--dart-define` (Phase 2 env template).
