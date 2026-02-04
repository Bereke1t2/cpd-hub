import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

import '../../../domain/entitiy/leaderboard_entry_entity.dart';
import '../../../domain/usecase/get_contest_leaderboard.dart';

part 'contest_leaderboard_event.dart';
part 'contest_leaderboard_state.dart';

class ContestLeaderboardBloc
    extends Bloc<ContestLeaderboardEvent, ContestLeaderboardState> {
  final GetContestLeaderboard getContestLeaderboard;

  ContestLeaderboardBloc({required this.getContestLeaderboard})
      : super(const ContestLeaderboardInitial()) {
    on<ContestLeaderboardStarted>(_onStarted);
  }

  Future<void> _onStarted(
    ContestLeaderboardStarted event,
    Emitter<ContestLeaderboardState> emit,
  ) async {
    emit(const ContestLeaderboardLoading());
    final result = await getContestLeaderboard(event.contestUrl);
    result.fold(
      (entries) => emit(ContestLeaderboardLoaded(entries)),
      (failure) => emit(ContestLeaderboardError(failure.message)),
    );
  }
}
