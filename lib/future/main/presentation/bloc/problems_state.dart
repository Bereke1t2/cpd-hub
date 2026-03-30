part of 'problems_cubit.dart';

abstract class ProblemsState extends Equatable {
  const ProblemsState();
  @override
  List<Object?> get props => [];
}

class ProblemsInitial extends ProblemsState {}

class ProblemsLoading extends ProblemsState {}

class ProblemsLoaded extends ProblemsState {
  final List<ProblemEntity> problems;
  final bool hasMore;
  final bool isLoadingMore;

  const ProblemsLoaded(
    this.problems, {
    this.hasMore = true,
    this.isLoadingMore = false,
  });

  ProblemsLoaded copyWith({
    List<ProblemEntity>? problems,
    bool? hasMore,
    bool? isLoadingMore,
  }) {
    return ProblemsLoaded(
      problems ?? this.problems,
      hasMore: hasMore ?? this.hasMore,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }

  @override
  List<Object?> get props => [problems, hasMore, isLoadingMore];
}

class ProblemsError extends ProblemsState {
  final String message;
  const ProblemsError(this.message);
  @override
  List<Object?> get props => [message];
}
