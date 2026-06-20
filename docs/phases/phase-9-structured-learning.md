# Phase 9 — Structured Learning (Topic Graph + Tracks)

**Goal:** Turn the app from a flat problem list into a **guided curriculum**. Give CP learners a clear
answer to *"what do I learn next, and what must I learn before it?"* by modelling CP knowledge as a
**topic dependency graph (DAG)**, surfacing a **skill tree**, and bundling each topic into a mini-course
(lesson + references + ordered problem set). Curated **Tracks** sequence topics into goal-oriented paths.

**Depends on:** Phase 4 (real-data layer + mock fallback), Phase 6 (`AsyncView`), Phase 1 (router/tokens).
**Risk:** Medium. New feature module + a graph engine, but it ships behind the existing mock-first pattern
and blocks nothing already working.

> This is the structural backbone for Phases 10 (ladders/streaks reference topics) and 11 (recommendations
> and strength analysis are per-topic). Build it first.

---

## Checklist
- [ ] 9.1 `features/learning/` module scaffolded (data / domain / presentation).
- [ ] 9.2 Domain entities: `TopicEntity` (with `prerequisiteIds`), `TrackEntity`, `LessonEntity`.
- [ ] 9.3 Mock data source: a real CP topic graph (~25–35 topics) with prereqs + problem mappings.
- [ ] 9.4 Path engine: classify every topic as `completed` / `available` / `locked` from solve progress.
- [ ] 9.5 `TopicsBloc` (graph + progress) and `TrackBloc` through `AsyncView`.
- [ ] 9.6 Skill-tree / roadmap page (the visual "before → after" map).
- [ ] 9.7 Topic detail page: lesson, references, ordered problem set with progress.
- [ ] 9.8 Tracks list + track detail (ordered topic sequence with % complete).
- [ ] 9.9 Router entries + a "Learn" entry point (new tab or Home section).
- [ ] 9.10 Cycle/validation guard on the graph (no topic can transitively require itself).

---

## 9.1 Module layout
```
lib/features/learning/
  data/
    datasources/
      learning_remote_data_source.dart      # interface + stub (mirrors main/)
      mock/mock_learning_data_source.dart    # the real graph lives here for now
    models/  topic_model.dart, track_model.dart, lesson_model.dart
    repository/ learning_repository_impl.dart
  domain/
    entity/  topic_entity.dart, track_entity.dart, lesson_entity.dart
    repository/ learning_repository.dart
    usecase/ get_topics.dart, get_tracks.dart, get_topic_detail.dart
    service/ learning_path_engine.dart       # pure Dart, unit-testable
  presentation/
    bloc/ topics/, tracks/
    page/ skill_tree_page.dart, topic_detail_page.dart,
          tracks_page.dart, track_detail_page.dart
    widget/ topic_node.dart, track_card.dart, progress_ring.dart
```
Follow the existing `Either<T, Failure>` (success on **Left** — see Phase 0) and "models extend entities"
conventions. Use `templates/feature_scaffold.md`.

## 9.2 Domain entities
```dart
class TopicEntity extends Equatable {
  final String id;                 // 'binary-search'
  final String name;               // 'Binary Search'
  final String category;           // 'Searching' | 'DP' | 'Graphs' | 'Math' | 'Strings' | ...
  final String summary;            // one-paragraph what/why
  final int difficulty;            // 1..5 (ordering hint within a category)
  final List<String> prerequisiteIds;  // edges of the DAG
  final List<String> problemIds;   // maps into existing ProblemEntity.problemId
  final List<String> referenceUrls;   // CP-Algorithms, USACO Guide, cp-algo
  // progress is computed, not stored on the entity (see 9.4)
}

class TrackEntity extends Equatable {
  final String id;                 // 'div2-survival'
  final String title;              // 'Div 2 A–C Survival Kit'
  final String description;
  final List<String> topicIds;     // ordered sequence
  final String icon;               // named-icon key
}

class LessonEntity extends Equatable {
  final String topicId;
  final String markdownBody;       // short concept explainer (render with flutter_markdown)
  final List<String> keyIdeas;     // bullet takeaways
}
```
`difficulty` orders topics **inside** a category for display; the DAG edges (`prerequisiteIds`) define the
hard "learn-before" ordering across categories.

## 9.3 Mock topic graph
Seed a realistic CP curriculum in `mock_learning_data_source.dart`. Example edges (not exhaustive):
```
basics → sorting → binary-search → two-pointers → prefix-sums
sorting → greedy
binary-search → binary-search-on-answer
prefix-sums → difference-arrays
graphs-intro → bfs-dfs → shortest-paths → {dijkstra, bellman-ford, floyd-warshall}
bfs-dfs → topological-sort → dp-on-dag
dsu → mst
dp-intro → {knapsack, lis} → interval-dp → {bitmask-dp, tree-dp, digit-dp}
math-basics → {number-theory, combinatorics} → probability
number-theory → modular-arithmetic → modular-inverse
strings-intro → hashing → {kmp, z-algorithm} → trie → suffix-structures
```
Map each topic's `problemIds` to existing mock problems (reuse what `mock_problems_data_source` already
serves; tag a handful per topic). Provide 2–4 `referenceUrls` per topic.

## 9.4 Path engine (the heart of "what's next")
Pure, dependency-free Dart so it's trivially unit-testable:
```dart
enum TopicStatus { completed, available, locked }

class TopicProgress {
  final TopicStatus status;
  final int solved;      // problems solved in this topic
  final int total;       // problems mapped to this topic
  double get ratio => total == 0 ? 0 : solved / total;
}

class LearningPathEngine {
  /// completionThreshold: fraction of a topic's problems needed to count it "done".
  Map<String, TopicProgress> classify(
    List<TopicEntity> topics,
    Set<String> solvedProblemIds, {
    double completionThreshold = 0.6,
  });
}
```
Rules:
- **completed** — `ratio >= completionThreshold`.
- **available** — not completed **and every** `prerequisiteIds` topic is completed (this is the
  "learn next" frontier).
- **locked** — at least one prerequisite is not completed (this is "learn before what").

`solvedProblemIds` comes from the user's solve state (Phase 5 interactions / profile). While offline or
pre-backend, derive it from the mock `isSolved` flags so the tree is interactive immediately.

## 9.5 BLoCs
- `TopicsBloc`: loads topics + the user's solved set, runs the engine, emits
  `TopicsLoaded(graph, progressById)`. Re-runs `classify` when a solve event arrives (listen to the
  Phase 5 solve action / a shared session signal) so the tree updates live.
- `TrackBloc`: loads tracks; per track computes % = completed-topics / total-topics using `TopicsBloc`'s
  progress map.
Both render through `AsyncView` (Phase 6). One BLoC per screen concern — pages never fake data.

## 9.6 Skill-tree page
The visual answer to the user's question. Requirements:
- Group by **category** (swimlanes) or render a real layered DAG; start with grouped lanes (simpler, looks
  great) and treat full graph layout as a stretch.
- Each `TopicNode` shows state visually: **completed** (filled/check), **available** (accented, "Start"),
  **locked** (dimmed + lock + a "needs: X, Y" hint listing unmet prereqs).
- A top "Up next" strip = the `available` frontier, sorted by `difficulty`. This is the single most useful
  surface — it literally tells the user what to do next.
- Tap a node → topic detail (9.7). Locked nodes are tappable but show what to finish first.

## 9.7 Topic detail page
A topic = a mini-course. Sections:
1. **Concept** — render `LessonEntity.markdownBody` (`flutter_markdown`) + `keyIdeas` bullets.
2. **References** — external links (open via `url_launcher`, lands well with Phase 7.D).
3. **Practice** — the topic's problem set, **ordered easy→hard**, each row reusing `ProblemCard` with a
   solved tick; a progress ring shows `solved/total`.
4. **Prerequisites** — chips linking to prereq topics (so "before what" is navigable both directions).

## 9.8 Tracks
- `tracks_page.dart`: list of `TrackCard`s with % complete and "continue where you left off".
- `track_detail_page.dart`: the ordered topic sequence as a vertical stepper; the first non-completed topic
  is highlighted as the current step.

## 9.9 Entry point + router
- Add `RouteNames.learn`, `RouteNames.topicDetail`, `RouteNames.tracks`, `RouteNames.trackDetail`.
- Surface it as either a new bottom-nav **"Learn"** tab or a prominent **"Continue learning"** section on
  Home showing the `available` frontier. Recommended: a Home section now, promote to a tab if it earns it.

## 9.10 Graph validation
On load (and in a test), assert the graph is a DAG: no cycles, every `prerequisiteId` and `problemId`
resolves to a real entity. A bad edge should fail loudly in debug, not silently lock a whole category.

---

## Definition of Done
- [ ] Topic graph loads (mock) and the skill tree renders completed / available / locked states.
- [ ] "Up next" shows the correct frontier and updates when a problem is marked solved.
- [ ] Locked topics list their unmet prerequisites; prereq chips navigate.
- [ ] Topic detail shows lesson + references + ordered, progress-tracked problem set.
- [ ] Tracks show real % complete and a clear "current step".
- [ ] `LearningPathEngine.classify` has unit tests (frontier, threshold, locked-by-prereq, cycle guard).
- [ ] All pages go through `AsyncView`; no hardcoded progress shipped.
