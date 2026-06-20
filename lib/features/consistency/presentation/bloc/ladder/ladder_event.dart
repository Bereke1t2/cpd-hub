part of 'ladder_bloc.dart';

abstract class LadderEvent extends Equatable {
  const LadderEvent();
  @override
  List<Object?> get props => [];
}

class LadderStarted extends LadderEvent {
  const LadderStarted();
}

class LadderRungSolved extends LadderEvent {
  final String ladderId;
  final String problemId;
  const LadderRungSolved({required this.ladderId, required this.problemId});
  @override
  List<Object?> get props => [ladderId, problemId];
}
