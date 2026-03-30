import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cpd_hub/future/main/domain/entitiy/problem_entitiy.dart';
import 'package:cpd_hub/future/main/domain/usecase/get_problems.dart';
import 'package:cpd_hub/future/main/domain/usecase/like_it.dart';
import 'package:cpd_hub/future/main/domain/usecase/dislike_it.dart';
import 'package:cpd_hub/future/main/domain/usecase/make_it_solved.dart';

part 'problems_state.dart';

class ProblemsCubit extends Cubit<ProblemsState> {
  final GetProblems getProblems;
  final LikeIt likeIt;
  final DislikeIt dislikeIt;
  final MakeItSolved makeItSolved;

  static const int _pageSize = 20;
  int _currentPage = 1;

  ProblemsCubit({
    required this.getProblems,
    required this.likeIt,
    required this.dislikeIt,
    required this.makeItSolved,
  }) : super(ProblemsInitial());

  Future<void> loadProblems() async {
    _currentPage = 1;
    emit(ProblemsLoading());
    final result = await getProblems(page: 1, limit: _pageSize);
    result.fold(
      (problems) => emit(ProblemsLoaded(
        problems,
        hasMore: problems.length >= _pageSize,
      )),
      (failure) => emit(ProblemsError(failure.message)),
    );
  }

  Future<void> loadMore() async {
    final currentState = state;
    if (currentState is! ProblemsLoaded || !currentState.hasMore || currentState.isLoadingMore) return;

    emit(currentState.copyWith(isLoadingMore: true));
    _currentPage++;

    final result = await getProblems(page: _currentPage, limit: _pageSize);
    result.fold(
      (newProblems) {
        final all = [...currentState.problems, ...newProblems];
        emit(ProblemsLoaded(
          all,
          hasMore: newProblems.length >= _pageSize,
        ));
      },
      (failure) {
        _currentPage--;
        emit(currentState.copyWith(isLoadingMore: false));
      },
    );
  }

  Future<void> likeProblem(String problemId) async {
    await likeIt(problemId);
    await _refreshProblems();
  }

  Future<void> dislikeProblem(String problemId) async {
    await dislikeIt(problemId);
    await _refreshProblems();
  }

  Future<void> markSolved(String problemId) async {
    await makeItSolved(problemId);
    await _refreshProblems();
  }

  Future<void> _refreshProblems() async {
    final result = await getProblems(page: 1, limit: _currentPage * _pageSize);
    result.fold(
      (problems) => emit(ProblemsLoaded(
        problems,
        hasMore: problems.length >= _currentPage * _pageSize,
      )),
      (_) {},
    );
  }
}
