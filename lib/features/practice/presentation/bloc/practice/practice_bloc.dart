import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lab_portal/features/learning/domain/entity/topic_entity.dart';
import 'package:lab_portal/features/learning/domain/service/learning_path_engine.dart';

import '../../../domain/entity/recommendation_entity.dart';
import '../../../domain/entity/review_item_entity.dart';
import '../../../domain/entity/solve_history.dart';
import '../../../domain/entity/topic_strength_entity.dart';
import '../../../domain/entity/upsolve_item_entity.dart';
import '../../../domain/service/recommender.dart';
import '../../../domain/service/sm2_scheduler.dart';
import '../../../domain/service/strength_analyzer.dart';
import '../../../domain/usecase/add_to_review.dart';
import '../../../domain/usecase/get_review_queue.dart';
import '../../../domain/usecase/get_upsolves.dart';
import '../../../domain/usecase/save_review_result.dart';
import '../../../domain/repository/practice_repository.dart';

part 'practice_event.dart';
part 'practice_state.dart';

class PracticeBloc extends Bloc<PracticeEvent, PracticeState> {
  final GetReviewQueue _getReviewQueue;
  final GetUpsolves _getUpsolves;
  final SaveReviewResult _saveReviewResult;
  final AddToReview _addToReview;
  final PracticeRepository _repo;
  final StrengthAnalyzer _analyzer;
  final Recommender _recommender;
  final Sm2Scheduler _scheduler;

  /// Injected externally from the ambient TopicsBloc so we don't load twice.
  List<TopicEntity> _topics = [];
  Map<String, TopicProgress> _graphProgress = {};
  Set<String> _solvedIds = {};

  PracticeBloc({
    required GetReviewQueue getReviewQueue,
    required GetUpsolves getUpsolves,
    required SaveReviewResult saveReviewResult,
    required AddToReview addToReview,
    required PracticeRepository repo,
    StrengthAnalyzer? analyzer,
    Recommender? recommender,
    Sm2Scheduler? scheduler,
  })  : _getReviewQueue = getReviewQueue,
        _getUpsolves = getUpsolves,
        _saveReviewResult = saveReviewResult,
        _addToReview = addToReview,
        _repo = repo,
        _analyzer = analyzer ?? const StrengthAnalyzer(),
        _recommender = recommender ?? const Recommender(),
        _scheduler = scheduler ?? const Sm2Scheduler(),
        super(const PracticeInitial()) {
    on<PracticeStarted>(_onStarted);
    on<PracticeReviewCompleted>(_onReviewCompleted);
    on<PracticeAddToReview>(_onAddToReview);
    on<PracticeUpsolveResolved>(_onUpsolveResolved);
  }

  /// Call before dispatching PracticeStarted so the bloc has graph context.
  void setTopicContext(
    List<TopicEntity> topics,
    Map<String, TopicProgress> progress,
    Set<String> solvedIds,
  ) {
    _topics = topics;
    _graphProgress = progress;
    _solvedIds = solvedIds;
  }

  Future<void> _onStarted(
    PracticeStarted _,
    Emitter<PracticeState> emit,
  ) async {
    emit(const PracticeLoading());

    final history = SolveHistory(solvedProblemIds: _solvedIds);
    final strengths = _analyzer.analyze(_topics, _graphProgress, history);
    final recommendations = _recommender.next(
      _topics,
      strengths,
      _graphProgress,
      history,
    );

    final reviewResult = await _getReviewQueue();
    final upsolveResult = await _getUpsolves();

    final allReviews = reviewResult.fold((r) => r, (_) => <ReviewItemEntity>[]);
    final dueReviews = _scheduler.dueItems(allReviews, DateTime.now());
    final upsolves = upsolveResult.fold((u) => u, (_) => <UpsolveItemEntity>[]);
    final pending = upsolves.where((u) => !u.resolved).toList();

    emit(PracticeLoaded(
      recommendations: recommendations,
      dueReviews: dueReviews,
      pendingUpsolves: pending,
      strengths: strengths,
    ));
  }

  Future<void> _onReviewCompleted(
    PracticeReviewCompleted event,
    Emitter<PracticeState> emit,
  ) async {
    await _saveReviewResult(event.item, event.recalled);
    if (state is! PracticeLoaded) return;
    final current = state as PracticeLoaded;
    // Remove from due list — it's been reviewed.
    final updated = current.dueReviews
        .where((r) => r.problemId != event.item.problemId)
        .toList();
    emit(current.copyWith(dueReviews: updated));
  }

  Future<void> _onAddToReview(
    PracticeAddToReview event,
    Emitter<PracticeState> emit,
  ) async {
    await _addToReview(event.problemId);
  }

  Future<void> _onUpsolveResolved(
    PracticeUpsolveResolved event,
    Emitter<PracticeState> emit,
  ) async {
    final resolved = event.item.markResolved();
    await _repo.saveUpsolve(resolved);
    if (state is! PracticeLoaded) return;
    final current = state as PracticeLoaded;
    final updated = current.pendingUpsolves
        .where((u) =>
            !(u.contestId == event.item.contestId &&
                u.problemId == event.item.problemId))
        .toList();
    emit(current.copyWith(pendingUpsolves: updated));
  }
}
