# Phase 15 — Courses (video · text · PDF, LeetCode style)

**Goal:** Add a real **course** section: a Course → Modules → Lessons hierarchy where each lesson is a
**video**, **article (text/markdown)**, or **PDF**, with per-lesson progress — the LeetCode "Explore /
Courses" experience.

**Depends on:** Phase 12 (responsive/perf), Phase 13 (component kit), Phase 6 (`AsyncView`).
Pairs naturally with Phase 9 (Structured Learning) — a topic can link to a course.
**Risk:** Medium-High. New third-party players (video/PDF) + new feature module. Ship mock-first, one
lesson kind at a time.

> Full module layout, entity definitions, JSON contract, player notes, and the pubspec additions are in
> [`templates/course_scaffold.md`](../templates/course_scaffold.md). Read it before starting.

---

## Checklist
- [ ] 15.1 Add deps: `video_player` + `chewie`, `flutter_markdown`, a PDF viewer (`syncfusion_flutter_pdfviewer` or `pdfx`), `url_launcher`.
- [ ] 15.2 `features/courses/` module (data/domain/presentation) per the scaffold.
- [ ] 15.3 Entities: `CourseEntity`, `ModuleEntity`, `LessonEntity` (+ `LessonKind`), with progress getters.
- [ ] 15.4 Mock data source: one full sample course covering all three lesson kinds.
- [ ] 15.5 `CoursesBloc` (list) + `CourseDetailBloc` (one course + progress) through `AsyncView`.
- [ ] 15.6 `CoursesPage` (grid of `CourseCard`) + `CourseDetailPage` (expandable modules → lessons).
- [ ] 15.7 `LessonPage` dispatching on `LessonKind`: `VideoPlayerView` / `ArticleView` / `PdfView`.
- [ ] 15.8 Progress: mark a lesson complete (video ~90% watched, article scroll-end, PDF last page / button); persist; bubble to module + course %.
- [ ] 15.9 Wire into nav (Learn tab or its own slot) + router + DI.
- [ ] 15.10 Backend contract: confirm `GET /api/courses` + `GET /api/courses/:id` JSON with the API team; until then, mock-first behind the data-source interface.

## Lesson players (the new surface area)
- **Video** — `video_player` + `chewie`. Initialize async (spinner until ready), dispose both
  controllers, wrap the player in a `RepaintBoundary`. Auto-complete at ~90% position.
- **Article** — `flutter_markdown` for inline or fetched markdown. Complete on scroll-to-end.
- **PDF** — `SfPdfViewer.network` (or `pdfx`). Complete on last page or an explicit "Mark complete".
- One `lesson_page.dart` switches on `kind` — see the scaffold's dispatch snippet.

## UX (LeetCode style)
- `CourseCard`: cover image, level `AppChip`, title, `LinearProgressIndicator`.
- `CourseDetailPage`: cover header + completion `ProgressRing`; modules as expandable tiles; each lesson
  row shows a kind icon (▶/📄/📕), duration, completion check; first incomplete lesson highlighted
  "Continue".
- `LessonPage`: full-screen player/reader + prev/next + "Next lesson".
- Everything composed from the Phase 13 kit (`AppCard`, `AppListTile`, `ProgressRing`, `AppChip`).

## Performance
- Never build all module lessons eagerly — expandable tiles build lessons on expand.
- Video/PDF views are heavy: isolate in `RepaintBoundary`, dispose controllers in `dispose()`, and
  pause/teardown on navigation away.

---

## Definition of Done
- [ ] Courses list + detail load (mock first) via `AsyncView`; no overflow at 360px.
- [ ] Video, article, and PDF lessons all render and play/scroll on web + one mobile target.
- [ ] Completing any lesson updates module + course progress and persists across restarts.
- [ ] No controller leaks; players isolated and disposed.
- [ ] Routed + reachable from the Learn surface.
