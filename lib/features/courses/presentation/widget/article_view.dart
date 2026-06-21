// Renders markdown. Marks complete when scrolled to the bottom.
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:lab_portal/core/theme/app_dimens.dart';
import 'package:lab_portal/core/ui_constants.dart';

class ArticleView extends StatefulWidget {
  final String markdown;
  final VoidCallback? onComplete;

  const ArticleView({super.key, required this.markdown, this.onComplete});

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
    if (_completeFired) return;
    if (_scroll.position.pixels >=
        _scroll.position.maxScrollExtent - 40) {
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
      padding: const EdgeInsets.all(AppDimens.lg),
      styleSheet: MarkdownStyleSheet(
        h1: const TextStyle(
            color: UiConstants.mainTextColor,
            fontSize: AppDimens.fH1,
            fontWeight: FontWeight.w900),
        h2: const TextStyle(
            color: UiConstants.mainTextColor,
            fontSize: AppDimens.fH2,
            fontWeight: FontWeight.w800),
        h3: const TextStyle(
            color: UiConstants.primaryButtonColor,
            fontSize: AppDimens.fTitle,
            fontWeight: FontWeight.w700),
        p: const TextStyle(
            color: UiConstants.mainTextColor,
            fontSize: AppDimens.fBody,
            height: 1.6),
        listBullet: const TextStyle(
            color: UiConstants.primaryButtonColor),
        code: TextStyle(
            backgroundColor:
                UiConstants.infoBackgroundColor,
            color: UiConstants.primaryButtonColor,
            fontFamily: 'monospace',
            fontSize: AppDimens.fBody),
        codeblockDecoration: BoxDecoration(
          color: UiConstants.infoBackgroundColor,
          borderRadius: AppDimens.brMd,
          border: Border.all(
              color: UiConstants.primaryButtonColor
                  .withValues(alpha: 0.20)),
        ),
        blockquoteDecoration: BoxDecoration(
          color: UiConstants.primaryButtonColor.withValues(alpha: 0.08),
          borderRadius: AppDimens.brSm,
          border: Border(
              left: BorderSide(
                  color: UiConstants.primaryButtonColor, width: 3)),
        ),
      ),
    );
  }
}
