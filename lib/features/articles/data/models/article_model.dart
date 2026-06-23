import '../../domain/entity/article_entity.dart';

class ArticleModel extends ArticleEntity {
  const ArticleModel({
    required super.id,
    required super.title,
    required super.author,
    required super.source,
    required super.sourceUrl,
    required super.excerpt,
    super.fullContent,
    required super.publishedAt,
    super.tags,
    super.rating,
  });

  /// Builds from a Codeforces `recentActions` result item.
  ///
  /// The [json] is the action wrapper that contains a `blogEntry` sub-object.
  factory ArticleModel.fromCodeforcesJson(Map<String, dynamic> json) {
    final blog = json['blogEntry'] as Map<String, dynamic>;
    final blogId = blog['id'] as int;
    final timeSeconds = blog['creationTimeSeconds'] as int;
    final content = blog['content'] as String? ?? '';
    final plainText = _stripHtml(content);
    final tags = (blog['tags'] as List<dynamic>?)
            ?.map((t) => t.toString())
            .toList() ??
        [];

    return ArticleModel(
      id: 'cf_$blogId',
      title: blog['title'] as String? ?? '(untitled)',
      author: blog['authorHandle'] as String? ?? 'unknown',
      source: 'Codeforces',
      sourceUrl: 'https://codeforces.com/blog/entry/$blogId',
      excerpt: _truncate(plainText, 150),
      fullContent: plainText.length > 150 ? plainText : null,
      publishedAt: DateTime.fromMillisecondsSinceEpoch(timeSeconds * 1000),
      tags: tags,
      rating: blog['rating'] as int?,
    );
  }

  /// Strips HTML tags and entities, collapsing whitespace.
  static String _stripHtml(String html) {
    return html
        .replaceAll(RegExp(r'<[^>]*>'), ' ')
        .replaceAll(RegExp(r'&[a-z]+;'), ' ')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();
  }

  /// Truncates to [maxLen] chars, appending "..." if needed.
  static String _truncate(String text, int maxLen) {
    if (text.length <= maxLen) return text;
    return '${text.substring(0, maxLen - 3)}...';
  }
}
