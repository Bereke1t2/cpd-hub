# Phase 8 — Testing, CI & Release

**Goal:** Lock in quality. Add unit/bloc/widget tests, CI, build flavors, and a release checklist.

**Depends on:** All prior phases (test what exists as it lands — don't wait until the end).
**Risk:** Low. Pure safety net.

> Better practice: write the tests **inside each phase** as you build. This phase is the consolidation +
> the bits that only make sense once the app is whole (CI, flavors, release).

---

## Checklist
- [ ] 8.1 Test dependencies + structure.
- [ ] 8.2 Unit tests: models (`fromJson`/`toJson`), usecases.
- [ ] 8.3 Bloc tests for every BLoC.
- [ ] 8.4 Widget tests for key pages (incl. async states).
- [ ] 8.5 Replace the default `widget_test.dart`.
- [ ] 8.6 CI (GitHub Actions): analyze + test on PR.
- [ ] 8.7 Build flavors (dev/staging/prod) via `--dart-define`.
- [ ] 8.8 Release checklist.

---

## 8.1 Dependencies
```yaml
dev_dependencies:
  bloc_test: ^10.0.0
  mocktail: ^1.0.4
```
Mirror `lib/` structure under `test/`.

## 8.2 Unit tests
- **Models:** round-trip `fromJson(toJson(x)) == x`; tolerate the field-name variants the parsers handle
  (`likes`/`numberOfLikes`, `url`/`problemUrl`).
- **Usecases:** verify they delegate to the repo and pass args through (mock the repo with `mocktail`).
- **Repo:** mock data sources; assert `Left = success` / `Right = Failure` mapping, and the
  exception→failure mapping from Phase 2.

## 8.3 Bloc tests
Use `bloc_test`. For each BLoC assert the emitted sequence:
```dart
blocTest<ProblemsBloc, ProblemsState>(
  'emits [Loading, Loaded] on start',
  build: () => ProblemsBloc(getProblems: mockGetProblems),
  act: (b) => b.add(const ProblemsStarted()),
  expect: () => [isA<ProblemsLoading>(), isA<ProblemsLoaded>()],
);
```
Cover: success, failure, search/filter, and (Phase 5) optimistic-update **rollback** on write failure.

## 8.4 Widget tests
- Each page renders loading → data → error via pumped BLoC states.
- `AsyncView` shows spinner/empty/retry correctly and Retry re-dispatches.
- Login form validation.

## 8.5 Replace default test
`test/widget_test.dart` is the Flutter counter boilerplate and will fail (no counter). Replace with a real
smoke test that pumps `MyApp` with mock DI and verifies the home shell renders.

## 8.6 CI
`.github/workflows/ci.yml`:
```yaml
name: ci
on: [pull_request, push]
jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: subosito/flutter-action@v2
        with: { channel: stable }
      - run: flutter pub get
      - run: flutter analyze
      - run: dart format --set-exit-if-changed lib test
      - run: flutter test
```

## 8.7 Flavors
Three configs via `--dart-define-from-file`:
```
env/dev.json      → USE_MOCK=true
env/staging.json  → USE_MOCK=false, API_BASE_URL=https://staging…
env/prod.json     → USE_MOCK=false, API_BASE_URL=https://api…   (gitignored)
```
Document build commands in the root README. Add `env/*.json` (except a committed `dev.json`) to
`.gitignore`.

## 8.8 Release checklist
- [ ] `flutter analyze` clean, `flutter test` green, coverage tracked.
- [ ] App icons + splash per platform.
- [ ] Version bump in `pubspec.yaml` (`version: x.y.z+build`).
- [ ] No `--dart-define` secrets committed; prod URL injected at build.
- [ ] Crash/error logging wired (e.g. Sentry) — optional but recommended.
- [ ] Smoke test signed release build on a real device (android/ios) and web.
- [ ] README updated: build/run per flavor, env vars.

---

## Definition of Done
- [ ] Models, usecases, repo, and every BLoC have tests.
- [ ] Default counter test removed.
- [ ] CI green on PRs (analyze + format + test).
- [ ] Three flavors build and point at the right backend.
- [ ] Release checklist completed for the first tagged build.
