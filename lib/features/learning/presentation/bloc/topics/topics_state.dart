part of 'topics_bloc.dart';

abstract class TopicsState extends Equatable {
  const TopicsState();
  @override
  List<Object?> get props => [];
}

class TopicsInitial extends TopicsState {
  const TopicsInitial();
}

class TopicsLoading extends TopicsState {
  const TopicsLoading();
}

class TopicsLoaded extends TopicsState {
  final List<TopicEntity> topics;
  final Map<String, TopicProgress> progress;
  final List<TopicEntity> frontier;
  final double overallRatio;

  const TopicsLoaded({
    required this.topics,
    required this.progress,
    required this.frontier,
    required this.overallRatio,
  });

  @override
  List<Object?> get props => [topics, progress, frontier, overallRatio];
}

class TopicsError extends TopicsState {
  final String message;
  const TopicsError(this.message);
  @override
  List<Object?> get props => [message];
}
