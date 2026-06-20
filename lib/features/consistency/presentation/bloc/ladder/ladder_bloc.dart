import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entity/ladder_entity.dart';
import '../../../domain/usecase/get_ladders.dart';
import '../../../domain/repository/consistency_repository.dart';

part 'ladder_event.dart';
part 'ladder_state.dart';

class LadderBloc extends Bloc<LadderEvent, LadderState> {
  final GetLadders _getLadders;
  final ConsistencyRepository _repo;

  LadderBloc({
    required GetLadders getLadders,
    required ConsistencyRepository repo,
  })  : _getLadders = getLadders,
        _repo = repo,
        super(const LadderInitial()) {
    on<LadderStarted>(_onStarted);
    on<LadderRungSolved>(_onRungSolved);
  }

  Future<void> _onStarted(
    LadderStarted event,
    Emitter<LadderState> emit,
  ) async {
    emit(const LadderLoading());
    final result = await _getLadders();
    result.fold(
      (ladders) => emit(LadderLoaded(ladders)),
      (failure) => emit(LadderError(failure.message)),
    );
  }

  Future<void> _onRungSolved(
    LadderRungSolved event,
    Emitter<LadderState> emit,
  ) async {
    if (state is! LadderLoaded) return;
    final current = (state as LadderLoaded).ladders;
    final updated = current.map((l) {
      if (l.id != event.ladderId) return l;
      return l.withRungSolved(event.problemId);
    }).toList();
    emit(LadderLoaded(updated));
    // Persist the updated ladder.
    final changedLadder = updated.firstWhere((l) => l.id == event.ladderId);
    await _repo.saveLadder(changedLadder);
  }
}
