# Course Feature Scaffold (Phase 15)

LeetCode-style courses: a **Course** has ordered **Modules**, each Module has ordered **Lessons**, and a
Lesson is one of three content kinds — **video**, **article (markdown/text)**, or **PDF**. Progress is
tracked per lesson.

```
lib/features/courses/
  data/
    datasources/
      courses_remote_data_source.dart   # GET /api/courses, /api/courses/:id
      mock/mock_courses_data_source.dart # offline-first sample course
    models/  course_model.dart, module_model.dart, lesson_model.dart
    repository/ courses_repository_impl.dart
  domain/
    entity/  course_entity.dart, module_entity.dart, lesson_entity.dart
    repository/ courses_repository.dart
    usecase/ get_courses.dart, get_course_detail.dart, mark_lesson_complete.dart
  presentation/
    bloc/ courses/ (list)  course_detail/ (one course + progress)
    page/ courses_page.dart, course_detail_page.dart, lesson_page.dart
    widget/ course_card.dart, module_tile.dart, lesson_tile.dart,
            video_player_view.dart, article_view.dart, pdf_view.dart
```

## Dependencies to add (pubspec.yaml)
```yaml
  video_player: ^2.9.2      # video lessons (network mp4 / HLS)
  chewie: ^1.8.5            # player controls UI on top of video_player
  flutter_markdown: ^0.7.4  # article lessons
  syncfusion_flutter_pdfviewer: ^27.1.48  # PDF lessons (or pdfx as a lighter alt)
  url_launcher: ^6.3.1      # "open in browser" fallback
```
> Document the per-platform setup in each player file's header (iOS `NSAppTransportSecurity`,
> Android `INTERNET` permission for streaming).

## Entities

```dart
enum LessonKind { video, article, pdf }

class LessonEntity extends Equatable {
  final String id;
  final String title;
  final LessonKind kind;
  final String contentUrl;   // mp4/HLS url, markdown url, or pdf url
  final String? inlineText;  // for article lessons served inline (no fetch)
  final Duration? duration;  // video length, for the list subtitle
  final bool completed;
  // props: [id, title, kind, contentUrl, inlineText, duration, completed]
}

class ModuleEntity extends Equatable {
  final String id;
  final String title;
  final List<LessonEntity> lessons;
  double get progress =>
      lessons.isEmpty ? 0 : lessons.where((l) => l.completed).length / lessons.length;
}

class CourseEntity extends Equatable {
  final String id;
  final String title;
  final String summary;
  final String coverUrl;
  final String level;        // Beginner / Intermediate / Advanced
  final List<ModuleEntity> modules;
  int get lessonCount => modules.fold(0, (n, m) => n + m.lessons.length);
  double get progress {
    final all = modules.expand((m) => m.lessons).toList();
    return all.isEmpty ? 0 : all.where((l) => l.completed).length / all.length;
  }
}
```

## JSON shape (backend contract to confirm)
```jsonc
// GET /api/courses/:id
{
  "id": "graphs-101",
  "title": "Graph Algorithms",
  "summary": "BFS to max-flow.",
  "coverUrl": "https://...",
  "level": "Intermediate",
  "modules": [
    { "id": "m1", "title": "Traversal", "lessons": [
      { "id": "l1", "title": "BFS", "kind": "video",
        "contentUrl": "https://cdn/.../bfs.mp4", "durationSec": 540, "completed": false },
      { "id": "l2", "title": "DFS notes", "kind": "article",
        "contentUrl": "", "inlineText": "# DFS\n...", "completed": false },
      { "id": "l3", "title": "Cheat sheet", "kind": "pdf",
        "contentUrl": "https://cdn/.../graphs.pdf", "completed": false }
    ]}
  ]
}
```

## Lesson player — dispatch on kind
`lesson_page.dart` picks the renderer:
```dart
Widget _body(LessonEntity l) {
  switch (l.kind) {
    case LessonKind.video:   return VideoPlayerView(url: l.contentUrl);
    case LessonKind.article: return ArticleView(markdown: l.inlineText ?? '', url: l.contentUrl);
    case LessonKind.pdf:     return PdfView(url: l.contentUrl);
  }
}
```

### `video_player_view.dart` (Chewie)
- `VideoPlayerController.networkUrl(Uri.parse(url))` → wrap in `ChewieController`
- Dispose both in `dispose()`. Show a spinner until `initialize()` completes.
- Auto-mark the lesson complete at ~90% watched (listen on the controller position).

### `article_view.dart`
- If `inlineText` non-empty, render it with `Markdown(data: ...)`.
- Else fetch `contentUrl` (Dio) and render the body. Mark complete on scroll-to-end.

### `pdf_view.dart`
- `SfPdfViewer.network(url)`. Mark complete when last page is reached, or on a manual
  "Mark complete" button (PDFs have no reliable "ended" signal).

## UI (LeetCode style) — build on Phase 12/13 components
- **`courses_page.dart`**: grid of `CourseCard` (cover image, title, level chip, `LinearProgressIndicator`).
- **`course_detail_page.dart`**: header (cover + % complete ring) then an expandable list of
  `ModuleTile`s; each expands to `LessonTile`s with a kind icon (▶ video / 📄 article / 📕 pdf),
  duration, and a completion check. First incomplete lesson is highlighted as "Continue".
- **`lesson_page.dart`**: full-screen player/reader + "Next lesson" button + prev/next nav.

## DI + routing
- Register data source → repo → usecases → `CoursesBloc` / `CourseDetailBloc` in `injection.dart`.
- `RouteNames.courses`, `RouteNames.courseDetail`, `RouteNames.lesson` in the router.
- Add a "Courses" entry to the Learn tab (Phase 9) or its own nav slot.

## Definition of Done
- [ ] Course list + detail load (mock first, then backend) through `AsyncView`.
- [ ] All three lesson kinds render and play/scroll correctly on web + one mobile target.
- [ ] Completing a lesson updates module + course progress and persists.
- [ ] Players dispose controllers (no leaks); video isolated in a RepaintBoundary.
- [ ] No fixed-px overflow on a 360-wide screen (use Phase 12 responsive scale).
