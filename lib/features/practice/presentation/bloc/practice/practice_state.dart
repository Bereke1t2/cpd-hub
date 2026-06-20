part of 'practice_bloc.dart';

abstract class PracticeState extends Equatable {
  const PracticeState();
  @override
  List<Object?> get props => [];
}

class PracticeInitial extends PracticeState {
  const PracticeInitial();
}

class PracticeLoading extends PracticeState {
  const PracticeLoading();
}

class PracticeLoaded extends PracticeState {
  final List<RecommendationEntity> recommendations;
  final List<ReviewItemEntity> dueReviews;
  final List<UpsolveItemEntity> pendingUpsolves;
  final List<TopicStrengthEntity> strengths;

  const PracticeLoaded({
    required this.recommendations,
    required this.dueReviews,
    required this.pendingUpsolves,
    required this.strengths,
  });

  bool get isEmpty =>
      recommendations.isEmpty &&
      dueReviews.isEmpty &&
      pendingUpsolves.isEmpty;

  PracticeLoaded copyWith({
    List<RecommendationEntity>? recommendations,
    List<ReviewItemEntity>? dueReviews,
    List<UpsolveItemEntity>? pendingUpsolves,
    List<TopicStrengthEntity>? strengths,
  }) =>
      PracticeLoaded(
        recommendations: recommendations ?? this.recommendations,
        dueReviews: dueReviews ?? this.dueReviews,
        pendingUpsolves: pendingUpsolves ?? this.pendingUpsolves,
        strengths: strengths ?? this.strengths,
      );

  @override
  List<Object?> get props =>
      [recommendations, dueReviews, pendingUpsolves, strengths];
}

class PracticeError extends PracticeState {
  final String message;
  const PracticeError(this.message);
  @override
  List<Object?> get props => [message];
}
