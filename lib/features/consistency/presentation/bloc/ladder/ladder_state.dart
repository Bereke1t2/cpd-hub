part of 'ladder_bloc.dart';

abstract class LadderState extends Equatable {
  const LadderState();
  @override
  List<Object?> get props => [];
}

class LadderInitial extends LadderState {
  const LadderInitial();
}

class LadderLoading extends LadderState {
  const LadderLoading();
}

class LadderLoaded extends LadderState {
  final List<LadderEntity> ladders;

  /// The first ladder that still has unsolved rungs — the active one.
  LadderEntity? get activeLadder {
    try {
      return ladders.firstWhere((l) => l.todaysRung != null);
    } catch (_) {
      return null;
    }
  }

  const LadderLoaded(this.ladders);
  @override
  List<Object?> get props => [ladders];
}

class LadderError extends LadderState {
  final String message;
  const LadderError(this.message);
  @override
  List<Object?> get props => [message];
}
