part of 'topics_bloc.dart';

abstract class TopicsEvent extends Equatable {
  const TopicsEvent();
  @override
  List<Object?> get props => [];
}

class TopicsStarted extends TopicsEvent {
  const TopicsStarted();
}

/// Fired after a problem is marked solved so the tree reclassifies live.
class TopicsSolvedProblemAdded extends TopicsEvent {
  final String problemId;
  const TopicsSolvedProblemAdded(this.problemId);
  @override
  List<Object?> get props => [problemId];
}
