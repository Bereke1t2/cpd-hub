part of 'practice_bloc.dart';

abstract class PracticeEvent extends Equatable {
  const PracticeEvent();
  @override
  List<Object?> get props => [];
}

class PracticeStarted extends PracticeEvent {
  const PracticeStarted();
}

class PracticeReviewCompleted extends PracticeEvent {
  final ReviewItemEntity item;
  final bool recalled;
  const PracticeReviewCompleted(this.item, {required this.recalled});
  @override
  List<Object?> get props => [item, recalled];
}

class PracticeAddToReview extends PracticeEvent {
  final String problemId;
  const PracticeAddToReview(this.problemId);
  @override
  List<Object?> get props => [problemId];
}

class PracticeUpsolveResolved extends PracticeEvent {
  final UpsolveItemEntity item;
  const PracticeUpsolveResolved(this.item);
  @override
  List<Object?> get props => [item];
}
