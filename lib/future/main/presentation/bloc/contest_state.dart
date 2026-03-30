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
  final bool hasMore;
  final bool isLoadingMore;

  const ContestLoaded(
    this.contests, {
    this.hasMore = true,
    this.isLoadingMore = false,
  });

  ContestLoaded copyWith({
    List<ContestEntitiy>? contests,
    bool? hasMore,
    bool? isLoadingMore,
  }) {
    return ContestLoaded(
      contests ?? this.contests,
      hasMore: hasMore ?? this.hasMore,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }

  @override
  List<Object?> get props => [contests, hasMore, isLoadingMore];
}

class ContestError extends ContestState {
  final String message;
  const ContestError(this.message);
  @override
  List<Object?> get props => [message];
}
