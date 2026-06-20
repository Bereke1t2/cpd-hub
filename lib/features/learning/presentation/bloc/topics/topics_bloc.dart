import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entity/topic_entity.dart';
import '../../../domain/service/learning_path_engine.dart';
import '../../../domain/usecase/get_topics.dart';

part 'topics_event.dart';
part 'topics_state.dart';

class TopicsBloc extends Bloc<TopicsEvent, TopicsState> {
  final GetTopics getTopics;
  final LearningPathEngine _engine;

  // Cached topics + solved ids so reclassification is cheap.
  List<TopicEntity> _topics = [];
  final Set<String> _solvedIds = {};

  TopicsBloc({
    required this.getTopics,
    LearningPathEngine? engine,
  })  : _engine = engine ?? const LearningPathEngine(),
        super(const TopicsInitial()) {
    on<TopicsStarted>(_onStarted);
    on<TopicsSolvedProblemAdded>(_onSolvedAdded);
  }

  Future<void> _onStarted(
    TopicsStarted event,
    Emitter<TopicsState> emit,
  ) async {
    emit(const TopicsLoading());
    final result = await getTopics();
    result.fold(
      (topics) {
        _topics = topics;
        assert(
          _engine.detectCycle(topics).isEmpty,
          'Topic graph contains a cycle — fix prerequisiteIds in mock data.',
        );
        emit(_buildLoaded());
      },
      (failure) => emit(TopicsError(failure.message)),
    );
  }

  void _onSolvedAdded(
    TopicsSolvedProblemAdded event,
    Emitter<TopicsState> emit,
  ) {
    _solvedIds.add(event.problemId);
    if (_topics.isNotEmpty) emit(_buildLoaded());
  }

  TopicsLoaded _buildLoaded() {
    final progress = _engine.classify(_topics, _solvedIds);
    return TopicsLoaded(
      topics: _topics,
      progress: progress,
      frontier: _engine.frontier(_topics, progress),
      overallRatio: _engine.overallRatio(progress),
    );
  }
}
