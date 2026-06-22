// Renders markdown. Marks complete when scrolled to the bottom.
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:lab_portal/core/theme/app_dimens.dart';
import 'package:lab_portal/core/ui_constants.dart';

class ArticleView extends StatefulWidget {
  final String markdown;
  final VoidCallback? onComplete;

  /// Reports reading progress (0–1) as the article is scrolled.
  final ValueChanged<double>? onProgress;

  const ArticleView({
    super.key,
    required this.markdown,
    this.onComplete,
    this.onProgress,
  });

  @override
  State<ArticleView> createState() => _ArticleViewState();
}

class _ArticleViewState extends State<ArticleView> {
  final _scroll = ScrollController();
  bool _completeFired = false;

  @override
  void initState() {
    super.initState();
    _scroll.addListener(_onScroll);
  }

  void _onScroll() {
    final max = _scroll.position.maxScrollExtent;
    final progress = max <= 0 ? 1.0 : (_scroll.position.pixels / max).clamp(0.0, 1.0);
    widget.onProgress?.call(progress);
    if (_completeFired) return;
    if (_scroll.position.pixels >= max - 40) {
      _completeFired = true;
      widget.onComplete?.call();
    }
  }

  @override
  void dispose() {
    _scroll.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Markdown(
      controller: _scroll,
      data: widget.markdown,
      padding: const EdgeInsets.fromLTRB(
          AppDimens.lg, AppDimens.lg, AppDimens.lg, AppDimens.xl),
      styleSheet: MarkdownStyleSheet(
        // Generous vertical rhythm between blocks.
        blockSpacing: AppDimens.md,
        h1: const TextStyle(
            color: UiConstants.mainTextColor,
            fontSize: AppDimens.fHero,
            fontWeight: FontWeight.w900,
            height: 1.3),
        h1Padding: const EdgeInsets.only(bottom: AppDimens.xs),
        h2: const TextStyle(
            color: UiConstants.mainTextColor,
            fontSize: AppDimens.fH1,
            fontWeight: FontWeight.w800,
            height: 1.3),
        h2Padding: const EdgeInsets.only(top: AppDimens.sm, bottom: AppDimens.xxs),
        h3: const TextStyle(
            color: UiConstants.primaryButtonColor,
            fontSize: AppDimens.fH2,
            fontWeight: FontWeight.w700),
        h3Padding: const EdgeInsets.only(top: AppDimens.xs),
        // Comfortable body text — slightly larger with airy line height.
        p: const TextStyle(
            color: UiConstants.mainTextColor,
            fontSize: AppDimens.fBody + 1,
            height: 1.7),
        strong: const TextStyle(
            color: UiConstants.mainTextColor, fontWeight: FontWeight.w800),
        em: const TextStyle(
            color: UiConstants.mainTextColor, fontStyle: FontStyle.italic),
        listBullet: const TextStyle(
            color: UiConstants.mainTextColor,
            fontSize: AppDimens.fBody + 1,
            height: 1.7),
        listIndent: AppDimens.xl,
        // Inline code: a subtle monospace pill.
        code: TextStyle(
            backgroundColor: UiConstants.backgroundColor,
            color: UiConstants.primaryButtonColor,
            fontFamily: 'monospace',
            fontSize: AppDimens.fBody),
        // Code blocks: padded, framed, monospace (scrolls sideways internally).
        codeblockPadding: const EdgeInsets.all(AppDimens.md),
        codeblockDecoration: BoxDecoration(
          color: UiConstants.backgroundColor,
          borderRadius: AppDimens.brMd,
          border: Border.all(
              color: UiConstants.primaryButtonColor.withValues(alpha: 0.20)),
        ),
        blockquotePadding: const EdgeInsets.all(AppDimens.md),
        blockquoteDecoration: BoxDecoration(
          color: UiConstants.primaryButtonColor.withValues(alpha: 0.08),
          borderRadius: AppDimens.brSm,
          border: const Border(
              left: BorderSide(
                  color: UiConstants.primaryButtonColor, width: 3)),
        ),
      ),
    );
  }
}
