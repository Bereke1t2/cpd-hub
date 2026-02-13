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

  ProblemsCubit({
    required this.getProblems,
    required this.likeIt,
    required this.dislikeIt,
    required this.makeItSolved,
  }) : super(ProblemsInitial());

  Future<void> loadProblems() async {
    emit(ProblemsLoading());
    final result = await getProblems();
    result.fold(
      (problems) => emit(ProblemsLoaded(problems)),
      (failure) => emit(ProblemsError(failure.message)),
    );
  }

  Future<void> likeProblem(String problemId) async {
    await likeIt(problemId);
  }

  Future<void> dislikeProblem(String problemId) async {
    await dislikeIt(problemId);
  }

  Future<void> markSolved(String problemId) async {
    await makeItSolved(problemId);
  }
}
