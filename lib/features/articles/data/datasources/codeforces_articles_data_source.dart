import 'package:dio/dio.dart';

import '../models/article_model.dart';
import 'articles_data_source.dart';

/// Fetches recent blog entries from the public Codeforces API.
class CodeforcesArticlesDataSource implements ArticlesDataSource {
  final Dio _dio;

  CodeforcesArticlesDataSource({required Dio dio}) : _dio = dio;

  static const _base = 'https://codeforces.com/api';

  @override
  Future<List<ArticleModel>> getArticles({
    required int maxCount,
    int offset = 0,
  }) async {
    final response = await _dio.get(
      '$_base/recentActions',
      queryParameters: {'maxCount': 100},
    );

    if (response.data is! Map<String, dynamic>) return [];
    final data = response.data as Map<String, dynamic>;
    if (data['status'] != 'OK') return [];

    final results = data['result'];
    if (results is! List) return [];

    // Collect blog-entry actions, skipping comments-on-blogs.
    final articles = <ArticleModel>[];
    final seenIds = <int>{};

    for (final item in results) {
      if (item is! Map<String, dynamic>) continue;
      final blog = item['blogEntry'];
      if (blog is! Map<String, dynamic>) continue;
      // comment != null means it's a comment, not a new blog post.
      if (item['comment'] != null) continue;

      final blogId = blog['id'] as int?;
      if (blogId == null || seenIds.contains(blogId)) continue;
      seenIds.add(blogId);

      try {
        articles.add(ArticleModel.fromCodeforcesJson(item));
      } catch (_) {
        // Skip malformed entries.
      }
    }

    // Page client-side: the API returns one batch, we slice it.
    return articles.skip(offset).take(maxCount).toList();
  }
}
