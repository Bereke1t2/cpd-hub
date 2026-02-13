part of 'contest_cubit.dart';

abstract class ContestState extends Equatable {
  const ContestState();
  @override
  List<Object?> get props => [];
}

class ContestInitial extends ContestState {}
class ContestLoading extends ContestState {}

class ContestLoaded extends ContestState {
  final List<ContestEntitiy> contests;
  const ContestLoaded(this.contests);
  @override
  List<Object?> get props => [contests];
}

class ContestError extends ContestState {
  final String message;
  const ContestError(this.message);
  @override
  List<Object?> get props => [message];
}
