import 'package:equatable/equatable.dart';

/// An article / blog post from a competitive programming platform.
class ArticleEntity extends Equatable {
  /// Unique ID with source prefix, e.g. "cf_789".
  final String id;

  final String title;
  final String author;

  /// Platform name — "Codeforces", "LeetCode", "AtCoder", etc.
  final String source;

  /// Full URL opened in the browser on tap.
  final String sourceUrl;

  /// First ~150 characters of the body, HTML tags stripped.
  final String excerpt;

  /// Full body text (HTML stripped), shown when the card is expanded.
  /// Nullable — not every source provides inline content.
  final String? fullContent;

  final DateTime publishedAt;

  /// Topic tags, e.g. ["dp", "graphs", "tutorial"].
  final List<String> tags;

  /// Upvote / rating count. Nullable — not every platform provides it.
  final int? rating;

  const ArticleEntity({
    required this.id,
    required this.title,
    required this.author,
    required this.source,
    required this.sourceUrl,
    required this.excerpt,
    this.fullContent,
    required this.publishedAt,
    this.tags = const [],
    this.rating,
  });

  @override
  List<Object?> get props => [
        id,
        title,
        author,
        source,
        sourceUrl,
        excerpt,
        fullContent,
        publishedAt,
        tags,
        rating,
      ];
}
