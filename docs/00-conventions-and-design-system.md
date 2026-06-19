# Phase 0 — Conventions & Design System

> Read this once before touching code. It defines the shared vocabulary every later phase assumes.

---

## 1. The `Either` orientation gotcha (read first)

This codebase uses `dartz` **inverted** from the usual convention:

```dart
// In THIS repo:
//   Left  = SUCCESS value
//   Right = Failure
Future<Either<List<ProblemEntity>, Failure>> getProblems();

result.fold(
  (problems) => emit(Loaded(problems)),   // Left  → success
  (failure)  => emit(Error(failure.message)), // Right → failure
);
```

The dartz community convention is the opposite (`Right` = success). **Do not "fix" this casually** —
every BLoC, repo, and usecase depends on the current orientation. If you ever standardize it, do it in
**one dedicated PR** that flips all `fold` calls and all `left()/right()` returns together.

> Convention for new code: **keep `Left = success`** until/unless that refactor lands.

---

## 2. Naming & file conventions

| Thing | Rule | Example |
|-------|------|---------|
| Folders | feature-first, lowercase | `features/auth/data/...` |
| Entities | `*_entity.dart`, class `XEntity` | `user_entity.dart` → `UserEntity` |
| Models | `*_model.dart`, `class XModel extends XEntity` | `UserModel` |
| BLoCs | folder per bloc with `part` files | `bloc/problems/{bloc,event,state}.dart` |
| Usecases | one verb-class per file | `GetProblems`, `LikeIt` |
| Pages | `*_page.dart`, class `XPage` | `profile_page.dart` |
| Widgets | `*.dart`, class `XBox`/`XCard` | `problem_box.dart` |

**Existing typos to fix in Phase 1** (keep a compatibility note in the PR):
- `domain/entitiy/` folder → should be `domain/entity/` (currently misspelled "entitiy").
- `info_entitity.dart` → `info_entity.dart`.
- `DailyProblemEntitiy` class → `DailyProblemEntity`.
- `ContestEntitiy` class → `ContestEntity`.
- `get_daily_problm.dart` → `get_daily_problem.dart`.

> These are wide renames. Do them mechanically with find/replace, run `flutter analyze`, commit alone.

---

## 3. Design-system tokens

Today widgets hardcode colors, 6+ border radii (8/12/14/16/18/22/28), and ad-hoc paddings. We centralize
all of it. Keep the existing `UiConstants` (colors) and **add** three token classes in `core/theme/`.

### `core/theme/app_spacing.dart`
```dart
import 'package:flutter/widgets.dart';

/// 4-pt spacing scale. Use these instead of literal EdgeInsets values.
class AppSpacing {
  AppSpacing._();
  static const double xxs = 4;
  static const double xs = 8;
  static const double sm = 12;
  static const double md = 16;
  static const double lg = 20;
  static const double xl = 24;
  static const double xxl = 32;

  static const EdgeInsets pageH = EdgeInsets.symmetric(horizontal: md);
  static const EdgeInsets card = EdgeInsets.all(md);
  static const SizedBox gapXs = SizedBox(height: xs, width: xs);
  static const SizedBox gapSm = SizedBox(height: sm, width: sm);
  static const SizedBox gapMd = SizedBox(height: md, width: md);
}
```

### `core/theme/app_radii.dart`
```dart
import 'package:flutter/widgets.dart';

/// Canonical corner radii. Collapse the existing 8/12/14/16/18/22/28 set into these.
class AppRadii {
  AppRadii._();
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 20;
  static const double pill = 999;

  static const BorderRadius rSm = BorderRadius.all(Radius.circular(sm));
  static const BorderRadius rMd = BorderRadius.all(Radius.circular(md));
  static const BorderRadius rLg = BorderRadius.all(Radius.circular(lg));
  static const BorderRadius rXl = BorderRadius.all(Radius.circular(xl));
}
```

### `core/theme/app_text_styles.dart`
```dart
import 'package:flutter/material.dart';
import '../ui_constants.dart';

/// Named text styles. Replace inline TextStyle(fontSize: ..) usages with these.
class AppTextStyles {
  AppTextStyles._();
  static const TextStyle h1 = TextStyle(
      fontSize: 24, fontWeight: FontWeight.w700, color: UiConstants.mainTextColor);
  static const TextStyle h2 = TextStyle(
      fontSize: 20, fontWeight: FontWeight.w600, color: UiConstants.mainTextColor);
  static const TextStyle title = TextStyle(
      fontSize: 16, fontWeight: FontWeight.w600, color: UiConstants.mainTextColor);
  static const TextStyle body = TextStyle(
      fontSize: 14, color: UiConstants.mainTextColor);
  static const TextStyle caption = TextStyle(
      fontSize: 12, color: UiConstants.subtitleTextColor);
  static const TextStyle stat = TextStyle(
      fontSize: 14, fontWeight: FontWeight.w600, color: UiConstants.statTextColor);
}
```

### `UiConstants` additions (shadows/elevation)
Add to the existing class so shadows stop being inline:
```dart
static const List<BoxShadow> cardShadow = [
  BoxShadow(color: shadowColor, blurRadius: 12, offset: Offset(0, 4)),
];
static Border get cardBorder => Border.all(color: borderColor);
```

**Migration rule:** new code MUST use tokens. When you touch an existing widget for any reason, swap its
literals to tokens opportunistically (boy-scout rule) — don't do a giant mechanical sweep.

---

## 4. State-shape convention (BLoC)

Every screen-level BLoC uses the same four-state shape so the shared `AsyncView` widget (Phase 6) works:

```
XInitial → XLoading → XLoaded(data, [query/filter]) → XError(message)
```

- Keep cached full lists in a private field (`List<T> _all`) for client-side filter, as `ProblemsBloc` does.
- Search/filter events emit a new `XLoaded` — never a new loading flicker.

---

## 5. DI convention (Phase 1 introduces `get_it`)

- One global `getIt` instance (`core/di/injection.dart`).
- Register **repos and data sources as lazy singletons**, **BLoCs as factories**.
- Pages get their BLoC via `getIt<XBloc>()` inside `BlocProvider(create: ...)`.
- `MainDI` is deleted once everything is migrated.

```dart
// usage in a page
BlocProvider(create: (_) => getIt<ProblemsBloc>()..add(const ProblemsStarted()))
```

---

## 6. Routing convention (Phase 1)

- All route names live in `core/routing/route_names.dart` as `static const`.
- `core/routing/app_router.dart` exposes `onGenerateRoute` for typed args (e.g. user id, problem id).
- Tabs keep simple names (`/`, `/problems`...). Detail screens take arguments via `settings.arguments`.

---

## 7. Error → message mapping

`core/error/` will hold both `Failure` (exists) and a new `exceptions.dart`. Data sources throw typed
exceptions; the repository `catch`es and maps to the right `Failure`:

| Exception (data layer) | Failure (domain) | User message |
|------------------------|------------------|--------------|
| `ServerException` | `ServerFailure` | "Something went wrong. Try again." |
| `UnauthorizedException` | `AuthenticationFailure` | "Please sign in again." |
| `NotFoundException` | `NotFoundFailure` | "Not found." |
| no connectivity | `NetworkFailure` | "No internet connection." |

The UI shows `failure.message`; keep messages human and short.

---

## 8. Definition of Done for Phase 0
- [ ] Everyone on the team has read sections 1 (Either gotcha) and 3 (tokens).
- [ ] `core/theme/{app_spacing,app_radii,app_text_styles}.dart` created and exported.
- [ ] `UiConstants` has `cardShadow` + `cardBorder`.
- [ ] Agreement recorded: keep `Left = success` for now.
