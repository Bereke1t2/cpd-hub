# Code Templates

Copy-paste starting points referenced by the phase docs. Paths in the header comment show where each file
belongs under `lib/`. They use the package name `lab_portal` (from `pubspec.yaml`) and follow the repo's
conventions — including **`Left = success`** for `Either` (see `../00-conventions-and-design-system.md`).

These are scaffolds, not finished code: fill the TODOs, wire real endpoints, and run `flutter analyze`.

| Template | Used in | Target path |
|----------|---------|-------------|
| `injection.dart` | Phase 1 | `lib/core/di/injection.dart` |
| `app_router.dart` | Phase 1 | `lib/core/routing/app_router.dart` (+ `route_names.dart`) |
| `app_config.dart` | Phase 2 | `lib/core/config/app_config.dart` |
| `exceptions.dart` | Phase 2 | `lib/core/error/exceptions.dart` |
| `dio_client.dart` | Phase 2 | `lib/core/network/dio_client.dart` |
| `token_store.dart` | Phase 3 | `lib/core/storage/token_store.dart` |
| `session_bloc.dart` | Phase 3 | `lib/features/auth/presentation/bloc/session/` |
| `async_view.dart` | Phase 6 | `lib/core/widgets/async_view.dart` |
| `feature_scaffold.md` | any new feature | folder layout + minimal files |
