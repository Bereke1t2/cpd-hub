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
| `ui_kit.dart` | Phases 9–11 | `lib/core/widgets/ui_kit.dart` (GradientCard, SectionHeader, ProgressRing, StatPill, StatusChip) |
| `learning_path_engine.dart` | Phase 9 | `lib/features/learning/domain/service/learning_path_engine.dart` (pure topic-graph classifier) |
| `skill_tree_widgets.dart` | Phase 9 | `lib/features/learning/presentation/widget/` (TopicNode, UpNextStrip, TopicStatusStyle) |
| `streak_engine.dart` | Phase 10 | `lib/features/consistency/domain/service/streak_engine.dart` (pure streak logic) |
| `consistency_widgets.dart` | Phase 10 | `lib/features/consistency/presentation/widget/` (StreakRing, GoalBar, LadderRungTile) |

> **Building any phase-9/10/11 screen? Read [`../01-ui-design-language.md`](../01-ui-design-language.md) first.**
> It defines the modern look and the per-screen specs; `ui_kit.dart` is its enforced building blocks.
