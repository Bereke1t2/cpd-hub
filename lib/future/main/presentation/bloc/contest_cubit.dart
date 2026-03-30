import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cpd_hub/future/main/domain/entitiy/contest_entitiy.dart';
import 'package:cpd_hub/future/main/domain/usecase/get_contests.dart';

part 'contest_state.dart';

class ContestCubit extends Cubit<ContestState> {
  final GetContests getContests;

  static const int _pageSize = 20;
  int _currentPage = 1;

  ContestCubit({required this.getContests}) : super(ContestInitial());

  Future<void> loadContests() async {
    _currentPage = 1;
    emit(ContestLoading());
    final result = await getContests(page: 1, limit: _pageSize);
    result.fold(
      (contests) => emit(ContestLoaded(
        contests,
        hasMore: contests.length >= _pageSize,
      )),
      (failure) => emit(ContestError(failure.message)),
    );
  }

  Future<void> loadMore() async {
    final currentState = state;
    if (currentState is! ContestLoaded || !currentState.hasMore || currentState.isLoadingMore) return;

    emit(currentState.copyWith(isLoadingMore: true));
    _currentPage++;

    final result = await getContests(page: _currentPage, limit: _pageSize);
    result.fold(
      (newContests) {
        final all = [...currentState.contests, ...newContests];
        emit(ContestLoaded(
          all,
          hasMore: newContests.length >= _pageSize,
        ));
      },
      (failure) {
        _currentPage--;
        emit(currentState.copyWith(isLoadingMore: false));
      },
    );
  }
}
