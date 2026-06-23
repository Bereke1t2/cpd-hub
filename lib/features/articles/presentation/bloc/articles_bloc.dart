import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

import '../../domain/entity/article_entity.dart';
import '../../domain/usecase/get_articles.dart';

// ── Events ─────────────────────────────────────────────────────────────────────

@immutable
sealed class ArticlesEvent {
  const ArticlesEvent();
}

/// Initial load (or refresh) of the first [pageSize] articles.
final class ArticlesStarted extends ArticlesEvent {
  final int maxCount;
  const ArticlesStarted({required this.maxCount});
}

/// Append the next page of articles to the existing list.
final class ArticlesLoadMore extends ArticlesEvent {
  const ArticlesLoadMore();
}

// ── States ─────────────────────────────────────────────────────────────────────

@immutable
sealed class ArticlesState {
  const ArticlesState();
}

final class ArticlesInitial extends ArticlesState {
  const ArticlesInitial();
}

final class ArticlesLoading extends ArticlesState {
  const ArticlesLoading();
}

final class ArticlesLoaded extends ArticlesState {
  final List<ArticleEntity> articles;

  /// Whether another page may be available (last fetch returned a full page).
  final bool hasMore;

  /// True while a "load more" fetch is in flight (keeps current list visible).
  final bool loadingMore;

  const ArticlesLoaded({
    required this.articles,
    this.hasMore = false,
    this.loadingMore = false,
  });

  ArticlesLoaded copyWith({
    List<ArticleEntity>? articles,
    bool? hasMore,
    bool? loadingMore,
  }) =>
      ArticlesLoaded(
        articles: articles ?? this.articles,
        hasMore: hasMore ?? this.hasMore,
        loadingMore: loadingMore ?? this.loadingMore,
      );
}

final class ArticlesError extends ArticlesState {
  final String message;
  const ArticlesError(this.message);
}

// ── Bloc ───────────────────────────────────────────────────────────────────────

class ArticlesBloc extends Bloc<ArticlesEvent, ArticlesState> {
  final GetArticles _getArticles;

  /// How many articles to fetch per page.
  int _pageSize = 5;

  ArticlesBloc({required GetArticles getArticles})
      : _getArticles = getArticles,
        super(const ArticlesInitial()) {
    on<ArticlesStarted>(_onStarted);
    on<ArticlesLoadMore>(_onLoadMore);
  }

  Future<void> _onStarted(
    ArticlesStarted event,
    Emitter<ArticlesState> emit,
  ) async {
    _pageSize = event.maxCount;
    emit(const ArticlesLoading());
    final result = await _getArticles(maxCount: _pageSize, offset: 0);
    result.fold(
      (articles) => emit(ArticlesLoaded(
        articles: articles,
        hasMore: articles.length >= _pageSize,
      )),
      (failure) => emit(ArticlesError(failure.message)),
    );
  }

  Future<void> _onLoadMore(
    ArticlesLoadMore event,
    Emitter<ArticlesState> emit,
  ) async {
    final current = state;
    if (current is! ArticlesLoaded) return;
    if (!current.hasMore || current.loadingMore) return;

    emit(current.copyWith(loadingMore: true));

    final result = await _getArticles(
      maxCount: _pageSize,
      offset: current.articles.length,
    );
    result.fold(
      (more) => emit(ArticlesLoaded(
        articles: [...current.articles, ...more],
        hasMore: more.length >= _pageSize,
        loadingMore: false,
      )),
      // On failure, keep what we have and stop offering "load more".
      (_) => emit(current.copyWith(hasMore: false, loadingMore: false)),
    );
  }
}
