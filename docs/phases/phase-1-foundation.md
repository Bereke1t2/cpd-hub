# Phase 1 — Foundation & Cleanup

**Goal:** Make the codebase ready to grow. Introduce design tokens, a service locator (`get_it`), a
central router, fix the naming typos, and delete dead code — without changing any user-visible behavior.

**Depends on:** Phase 0 (tokens defined).
**Risk:** Low. Mostly mechanical. The app still runs on mock data at the end.

---

## Checklist
- [ ] 1.1 Add the design-system token files (from Phase 0).
- [ ] 1.2 Add `get_it`; create `core/di/injection.dart`; migrate `MainDI` callers.
- [ ] 1.3 Add central router (`core/routing/`).
- [ ] 1.4 Fix `entitiy` → `entity` rename + `*Entitiy` class names + `get_daily_problm`.
- [ ] 1.5 Decide on `MainBloc`: delete (recommended) or finish.
- [ ] 1.6 Fix `SearchBox` clear button (it currently only unfocuses).
- [ ] 1.7 `flutter analyze` clean, app runs identically.

---

## 1.1 Design tokens
Create the three files from [Phase 0 §3](../00-conventions-and-design-system.md). Add `cardShadow` and
`cardBorder` to `UiConstants`. Nothing consumes them yet — that's fine.

## 1.2 Service locator (`get_it`)

Add to `pubspec.yaml` dependencies:
```yaml
  get_it: ^8.0.0
```

Create `lib/core/di/injection.dart` — see [`templates/injection.dart`](../templates/injection.dart).
It registers the repo + data sources as lazy singletons and each BLoC as a factory. Then:

In `main.dart`:
```dart
import 'core/di/injection.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  configureDependencies();   // registers everything
  runApp(const MyApp());
}
```

Replace `MainDI.buildXBloc()` call sites with `getIt<XBloc>()`. Example in a page:
```dart
// before
BlocProvider(create: (_) => MainDI.buildProblemsBloc()..add(const ProblemsStarted()))
// after
BlocProvider(create: (_) => getIt<ProblemsBloc>()..add(const ProblemsStarted()))
```
Delete `main_di.dart` once no references remain (`grep -r MainDI lib`).

> Why: `MainDI.buildRepo()` builds a **new** repo (and 5 new mock sources) on every page open. Singletons
> fix that and let us swap mock→remote in one place (Phase 4).

## 1.3 Central router
Create `core/routing/route_names.dart` and `core/routing/app_router.dart` from
[`templates/app_router.dart`](../templates/app_router.dart). Wire it in `MyApp`:
```dart
MaterialApp(
  title: 'CPD Hub',
  debugShowCheckedModeBanner: false,
  theme: AppTheme.dark,                 // Phase 6 swaps this in; ThemeData for now
  initialRoute: RouteNames.home,
  onGenerateRoute: AppRouter.onGenerateRoute,
);
```
Keep the existing tab routes working. Detail pages (`problem`, `user`, `contestLeaderboard`) now take
arguments through the router instead of inline `MaterialPageRoute`.

## 1.4 Rename typos
Mechanical, do it in isolation:
```bash
# folders/files
git mv lib/future/main/domain/entitiy lib/future/main/domain/entity
git mv lib/future/main/domain/entity/info_entitity.dart lib/future/main/domain/entity/info_entity.dart
git mv lib/future/main/domain/usecase/get_daily_problm.dart lib/future/main/domain/usecase/get_daily_problem.dart
```
Then find/replace across `lib` + `test`:
- `domain/entitiy/` → `domain/entity/`
- `DailyProblemEntitiy` → `DailyProblemEntity`
- `ContestEntitiy` → `ContestEntity`
- `GetDailyProblems` import path update.

Run `flutter analyze`; fix imports until clean. Commit alone with message `chore: fix entity naming typos`.

## 1.5 `MainBloc` decision
`main_bloc.dart` has a TODO handler and is never provided. **Recommended: delete** `bloc/main_bloc.dart`,
`main_event.dart`, `main_state.dart`. If you want a global app/nav bloc later, Phase 3's `SessionBloc`
covers session; per-screen BLoCs cover the rest. Confirm nothing imports it (`grep -r MainBloc lib`).

## 1.6 Fix `SearchBox`
The clear (×) button currently calls unfocus instead of clearing. Make it controller-driven:
```dart
// SearchBox should accept a TextEditingController and an onChanged.
IconButton(
  icon: const Icon(Icons.close),
  onPressed: () {
    controller.clear();
    onChanged('');          // tell the BLoC the query is now empty
    FocusScope.of(context).unfocus();
  },
)
```

---

## Definition of Done
- [ ] `flutter analyze` reports no issues.
- [ ] App launches and every tab behaves exactly as before (still mock data).
- [ ] `grep -r "MainDI\|MainBloc\|Entitiy\|entitiy" lib` returns nothing.
- [ ] All pages obtain BLoCs via `getIt`.
- [ ] Search clear button empties the field and resets results.
