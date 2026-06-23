import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:lab_portal/core/theme/app_dimens.dart';
import 'package:lab_portal/core/theme/app_text_styles.dart';
import 'package:lab_portal/core/ui_constants.dart';
import 'package:lab_portal/core/widgets/app_chip.dart';
import 'package:lab_portal/core/widgets/ui_kit.dart';

import '../../domain/entity/article_entity.dart';

/// An expandable LinkedIn-style article card for the feed.
///
/// Collapsed: shows author, title, excerpt (3 lines), "...more" hint.
/// Expanded: shows the full content inline, "Show less" to collapse.
/// Always shows date, rating, and an "Open in browser" link.
class ArticleCard extends StatefulWidget {
  final ArticleEntity article;

  const ArticleCard({super.key, required this.article});

  @override
  State<ArticleCard> createState() => _ArticleCardState();
}

class _ArticleCardState extends State<ArticleCard> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final a = widget.article;
    final sourceColor = _sourceColor(a.source);
    final hasFullContent = a.fullContent != null && a.fullContent!.isNotEmpty;

    return GradientCard(
      padding: const EdgeInsets.all(AppDimens.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Header: avatar + author + source chip ─────────────────────
          Row(
            children: [
              _Avatar(initials: _initials(a.author), color: sourceColor),
              const SizedBox(width: AppDimens.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(a.author,
                        style: AppTextStyles.title.copyWith(fontSize: 13)),
                    Text(_formatDate(a.publishedAt),
                        style: AppTextStyles.micro),
                  ],
                ),
              ),
              AppChip(a.source, color: sourceColor),
            ],
          ),
          const SizedBox(height: AppDimens.sm),

          // ── Title ─────────────────────────────────────────────────────
          Text(a.title,
              style: AppTextStyles.title.copyWith(
                fontWeight: FontWeight.w800,
                height: 1.3,
              )),
          const SizedBox(height: AppDimens.xs),

          // ── Content ───────────────────────────────────────────────────
          AnimatedSize(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeInOut,
            alignment: Alignment.topCenter,
            child: _expanded
                ? _ExpandedContent(article: a)
                : _CollapsedPreview(article: a, hasMore: hasFullContent),
          ),

          // ── Expand / collapse hint ────────────────────────────────────
          if (hasFullContent)
            GestureDetector(
              onTap: () => setState(() => _expanded = !_expanded),
              child: Padding(
                padding: const EdgeInsets.only(top: AppDimens.xs),
                child: Text(
                  _expanded ? 'Show less' : '...read more',
                  style: TextStyle(
                    color: UiConstants.primaryButtonColor,
                    fontSize: AppDimens.fCaption,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),

          const SizedBox(height: AppDimens.sm),
          const Divider(color: UiConstants.borderColor, height: 1),
          const SizedBox(height: AppDimens.sm),

          // ── Footer: stats + external link ─────────────────────────────
          Row(
            children: [
              if (a.rating != null) ...[
                Icon(Icons.thumb_up_rounded,
                    size: 13, color: UiConstants.ratingTextColor),
                const SizedBox(width: 3),
                Text('${a.rating}',
                    style: AppTextStyles.micro
                        .copyWith(color: UiConstants.ratingTextColor)),
                const SizedBox(width: AppDimens.sm),
              ],
              const Spacer(),
              GestureDetector(
                onTap: () => _openUrl(a.sourceUrl),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.open_in_new_rounded,
                        size: 13, color: UiConstants.primaryButtonColor),
                    const SizedBox(width: 3),
                    Text('Open in ${a.source}',
                        style: AppTextStyles.micro.copyWith(
                            color: UiConstants.primaryButtonColor)),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ── Helpers ───────────────────────────────────────────────────────────

  String _initials(String name) {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.length >= 2) {
      return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
    }
    return name.isNotEmpty ? name[0].toUpperCase() : '?';
  }

  String _formatDate(DateTime dt) {
    final now = DateTime.now();
    final diff = now.difference(dt);
    if (diff.inDays == 0) return 'Today';
    if (diff.inDays == 1) return 'Yesterday';
    if (diff.inDays < 7) return '${diff.inDays}d ago';
    if (diff.inDays < 30) return '${(diff.inDays / 7).floor()}w ago';
    return '${dt.day}/${dt.month}/${dt.year}';
  }

  Color _sourceColor(String source) {
    switch (source) {
      case 'Codeforces':
        return const Color(0xFFFF5722);
      case 'LeetCode':
        return const Color(0xFFFFC107);
      case 'AtCoder':
        return const Color(0xFF4FC3F7);
      default:
        return UiConstants.primaryButtonColor;
    }
  }

  Future<void> _openUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}

// ── Avatar circle ──────────────────────────────────────────────────────────────

class _Avatar extends StatelessWidget {
  final String initials;
  final Color color;
  const _Avatar({required this.initials, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: [color, color.withValues(alpha: 0.6)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      alignment: Alignment.center,
      child: Text(
        initials,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}

// ── Collapsed preview ─────────────────────────────────────────────────────────

class _CollapsedPreview extends StatelessWidget {
  final ArticleEntity article;
  final bool hasMore;
  const _CollapsedPreview({required this.article, required this.hasMore});

  @override
  Widget build(BuildContext context) {
    return Text(
      article.excerpt,
      maxLines: 3,
      overflow: TextOverflow.ellipsis,
      style: const TextStyle(
        color: UiConstants.subtitleTextColor,
        fontSize: AppDimens.fBody,
        height: 1.55,
      ),
    );
  }
}

// ── Expanded content ──────────────────────────────────────────────────────────

class _ExpandedContent extends StatelessWidget {
  final ArticleEntity article;
  const _ExpandedContent({required this.article});

  @override
  Widget build(BuildContext context) {
    final text = article.fullContent ?? article.excerpt;
    // No inner scroll view — the text renders full height and the parent
    // page scroll handles overflow, so the page scrolls (not the card).
    return Text(
      text,
      style: const TextStyle(
        color: UiConstants.subtitleTextColor,
        fontSize: AppDimens.fBody,
        height: 1.55,
      ),
    );
  }
}
