import '../models/article_model.dart';

abstract class ArticlesDataSource {
  /// Returns up to [maxCount] recent articles, skipping the first [offset].
  /// Used for pagination — pass an increasing [offset] to load more.
  Future<List<ArticleModel>> getArticles({
    required int maxCount,
    int offset = 0,
  });
}
