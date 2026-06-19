# Phase 5 — User Interactions (Like / Dislike / Solve / Bookmark)

**Goal:** Make the write actions real with **optimistic UI**. Today the like/dislike/mark-solved buttons
have empty `onPressed`; the repo methods route to unimplemented remote calls.

**Depends on:** Phase 4 (remote reads working).
**Risk:** Medium. Optimistic updates need correct rollback on failure.

---

## Checklist
- [ ] 5.1 Implement write endpoints in `RemoteDataSourceImpl`.
- [ ] 5.2 Add usecases wiring (most exist: `LikeIt`, `DislikeIt`, `MakeItSolved`; add unmark).
- [ ] 5.3 Per-problem interaction handling in a BLoC with optimistic update + rollback.
- [ ] 5.4 Wire `LikedAndDislikedButtons` + solve button to dispatch events.
- [ ] 5.5 Bookmarks (local persistence first, server later).

---

## 5.1 Remote write endpoints
Implement the four stubs (`likeProblem`, `dislikeProblem`, `markProblemAsSolved`, `unmarkProblemAsSolved`):
```dart
@override
Future<void> likeProblem(String problemId) =>
    _dio.post(UrlConstants.likeProblemUrl, data: {'problemId': problemId});
```
These return `void`; the repo already wraps them as `Either<void, Failure>`.

## 5.2 Usecases
`LikeIt`, `DislikeIt`, `MakeItSolved` exist. Add `UnmarkSolved` (mirror `MakeItSolved`) and register the
new one in DI. Add `unmarkProblemAsSolved` to the repo path if not already exposed via a usecase.

## 5.3 Optimistic interaction BLoC
Add events to `ProblemsBloc` (and `DailyProblemBloc`) for actions. Pattern:
1. User taps Like.
2. Immediately emit a `Loaded` state with the toggled flag + adjusted count (optimistic).
3. Call the usecase.
4. On failure → emit the **previous** state back and surface a snackbar message.

```dart
Future<void> _onToggleLike(ToggleLike e, Emitter emit) async {
  final prev = _all;
  _all = _applyLike(_all, e.problemId);          // optimistic
  emit(ProblemsLoaded(problems: _all));
  final res = await likeIt(e.problemId);
  res.fold(
    (_) {},                                       // success: keep optimistic state
    (failure) {                                   // failure: rollback
      _all = prev;
      emit(ProblemsLoaded(problems: _all));
      emit(ProblemsActionError(failure.message)); // transient; UI shows snackbar
    },
  );
}
```
Keep `_applyLike`/`_applyDislike`/`_applySolved` as pure helpers that return a new list with the target
problem's flags/counts updated (mutually exclusive like vs dislike).

> Add a `ProblemEntity.copyWith` (the entity is immutable/Equatable) so helpers can produce updated items.

## 5.4 Wire the widgets
`LikedAndDislikedButtons` and the solve button currently have `onPressed: () {}`. Pass callbacks down or
read the BLoC via context:
```dart
onLike: () => context.read<ProblemsBloc>().add(ToggleLike(problem.problemId)),
```
Reflect state in the icon (filled when `isLiked`) and the count.

## 5.5 Bookmarks
Start local: `shared_preferences` storing a `Set<String>` of bookmarked problem ids. A tiny
`BookmarksCubit` exposes the set; the bookmark icon toggles membership. Move to server when an endpoint
exists. Add `shared_preferences: ^2.3.0` to pubspec.

---

## Definition of Done
- [ ] Liking/disliking/solving updates the UI instantly and persists to the backend.
- [ ] A failed write rolls back the UI and shows a snackbar.
- [ ] Like and dislike are mutually exclusive; counts stay correct.
- [ ] Bookmarks survive app restart.
- [ ] No empty `onPressed: () {}` remain on these controls.
