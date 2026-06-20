import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

import '../../../domain/entity/problem_entity.dart';
import '../../../domain/usecase/get_problems.dart';
import '../../../domain/usecase/like_it.dart';
import '../../../domain/usecase/dislike_it.dart';
import '../../../domain/usecase/make_it_solved.dart';
import '../../../domain/usecase/unmark_solved.dart';

part 'problems_event.dart';
part 'problems_state.dart';

class ProblemsBloc extends Bloc<ProblemsEvent, ProblemsState> {
  final GetProblems getProblems;
  final LikeIt likeIt;
  final DislikeIt dislikeIt;
  final MakeItSolved makeItSolved;
  final UnmarkSolved unmarkSolved;

  List<ProblemEntity> _all = const [];

  ProblemsBloc({
    required this.getProblems,
    required this.likeIt,
    required this.dislikeIt,
    required this.makeItSolved,
    required this.unmarkSolved,
  }) : super(const ProblemsInitial()) {
    on<ProblemsStarted>(_onStarted);
    on<ProblemsSearchChanged>(_onSearchChanged);
    on<ProblemLikeToggled>(_onLikeToggled);
    on<ProblemDislikeToggled>(_onDislikeToggled);
    on<ProblemSolvedToggled>(_onSolvedToggled);
  }

  // ---- helpers ----

  String get _currentQuery =>
      state is ProblemsLoaded ? (state as ProblemsLoaded).query : '';

  ProblemsLoaded _filtered(String query) {
    final q = query.trim().toLowerCase();
    final problems = q.isEmpty
        ? _all
        : _all
            .where((p) =>
                p.title.toLowerCase().contains(q) ||
                p.difficulty.toLowerCase().contains(q))
            .toList();
    return ProblemsLoaded(problems: problems, query: query);
  }

  List<ProblemEntity> _replace(ProblemEntity updated) => [
        for (final p in _all)
          if (p.problemId == updated.problemId) updated else p,
      ];

  // ---- load ----

  Future<void> _onStarted(
    ProblemsStarted event,
    Emitter<ProblemsState> emit,
  ) async {
    emit(const ProblemsLoading());
    final result = await getProblems();
    result.fold(
      (problems) {
        _all = problems;
        emit(ProblemsLoaded(problems: problems));
      },
      (failure) => emit(ProblemsError(failure.message)),
    );
  }

  void _onSearchChanged(
    ProblemsSearchChanged event,
    Emitter<ProblemsState> emit,
  ) =>
      emit(_filtered(event.query));

  // ---- interactions (optimistic update → call remote → rollback on failure) ----

  Future<void> _onLikeToggled(
    ProblemLikeToggled event,
    Emitter<ProblemsState> emit,
  ) async {
    final idx = _all.indexWhere((p) => p.problemId == event.problemId);
    if (idx == -1) return;
    final p = _all[idx];
    final prev = List<ProblemEntity>.from(_all);
    final query = _currentQuery;

    final wasLiked = p.isLiked;
    _all = _replace(p.copyWith(
      isLiked: !wasLiked,
      numberOfLikes: wasLiked ? p.numberOfLikes - 1 : p.numberOfLikes + 1,
      isDisliked: wasLiked ? p.isDisliked : false,
      numberOfDislikes: (!wasLiked && p.isDisliked)
          ? p.numberOfDislikes - 1
          : p.numberOfDislikes,
    ));
    emit(_filtered(query));

    final result =
        wasLiked ? await dislikeIt(event.problemId) : await likeIt(event.problemId);
    result.fold(
      (_) {},
      (failure) {
        _all = prev;
        emit(_filtered(query));
        emit(ProblemsActionError(failure.message));
      },
    );
  }

  Future<void> _onDislikeToggled(
    ProblemDislikeToggled event,
    Emitter<ProblemsState> emit,
  ) async {
    final idx = _all.indexWhere((p) => p.problemId == event.problemId);
    if (idx == -1) return;
    final p = _all[idx];
    final prev = List<ProblemEntity>.from(_all);
    final query = _currentQuery;

    final wasDisliked = p.isDisliked;
    _all = _replace(p.copyWith(
      isDisliked: !wasDisliked,
      numberOfDislikes:
          wasDisliked ? p.numberOfDislikes - 1 : p.numberOfDislikes + 1,
      isLiked: wasDisliked ? p.isLiked : false,
      numberOfLikes: (!wasDisliked && p.isLiked)
          ? p.numberOfLikes - 1
          : p.numberOfLikes,
    ));
    emit(_filtered(query));

    final result = wasDisliked
        ? await likeIt(event.problemId)
        : await dislikeIt(event.problemId);
    result.fold(
      (_) {},
      (failure) {
        _all = prev;
        emit(_filtered(query));
        emit(ProblemsActionError(failure.message));
      },
    );
  }

  Future<void> _onSolvedToggled(
    ProblemSolvedToggled event,
    Emitter<ProblemsState> emit,
  ) async {
    final idx = _all.indexWhere((p) => p.problemId == event.problemId);
    if (idx == -1) return;
    final p = _all[idx];
    final prev = List<ProblemEntity>.from(_all);
    final query = _currentQuery;

    final wasSolved = p.isSolved;
    _all = _replace(p.copyWith(
      isSolved: !wasSolved,
      numberOfSolvedPeople: wasSolved
          ? p.numberOfSolvedPeople - 1
          : p.numberOfSolvedPeople + 1,
    ));
    emit(_filtered(query));

    final result = wasSolved
        ? await unmarkSolved(event.problemId)
        : await makeItSolved(event.problemId);
    result.fold(
      (_) {},
      (failure) {
        _all = prev;
        emit(_filtered(query));
        emit(ProblemsActionError(failure.message));
      },
    );
  }
}
