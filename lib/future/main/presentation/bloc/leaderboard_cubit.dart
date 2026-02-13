import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cpd_hub/future/main/domain/entitiy/leaderboard_entry_entity.dart';
import 'package:cpd_hub/future/main/domain/usecase/get_leaderboard.dart';

part 'leaderboard_state.dart';

class LeaderboardCubit extends Cubit<LeaderboardState> {
  final GetLeaderboard getLeaderboard;

  LeaderboardCubit({required this.getLeaderboard}) : super(LeaderboardInitial());

  Future<void> loadLeaderboard(String contestId) async {
    emit(LeaderboardLoading());
    final result = await getLeaderboard(contestId);
    result.fold(
      (entries) => emit(LeaderboardLoaded(entries)),
      (failure) => emit(LeaderboardError(failure.message)),
    );
  }
}
