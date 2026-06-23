import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:lab_portal/core/theme/app_dimens.dart';
import 'package:lab_portal/core/ui_constants.dart';
import 'package:lab_portal/core/widgets/branded_loader.dart';

import '../../presentation/bloc/articles_bloc.dart';
import 'article_card.dart';

/// A self-contained vertical feed of expandable article cards.
///
/// Takes a pre-created [ArticlesBloc] and handles loading / loaded / error
/// states internally — shows shimmer placeholders while loading, hides
/// entirely on error or empty.
class ArticleFeed extends StatelessWidget {
  final String title;
  final ArticlesBloc bloc;
  final int maxCount;

  const ArticleFeed({
    super.key,
    required this.title,
    required this.bloc,
    required this.maxCount,
  });

  @override
  Widget build(BuildContext context) {
    // Kick off the first fetch only when nothing has loaded yet. Firing on
    // every build would reset the list whenever "load more" updates state.
    if (bloc.state is ArticlesInitial) {
      bloc.add(ArticlesStarted(maxCount: maxCount));
    }

    return BlocBuilder<ArticlesBloc, ArticlesState>(
      bloc: bloc,
      builder: (context, state) {
        if (state is ArticlesError || state is ArticlesInitial) {
          return const SizedBox.shrink();
        }

        if (state is ArticlesLoading) {
          return _buildSection(_shimmerList());
        }

        if (state is ArticlesLoaded) {
          if (state.articles.isEmpty) return const SizedBox.shrink();
          return _buildSection(
            Column(
              children: [
                ...state.articles.map((a) => Padding(
                      padding: const EdgeInsets.only(bottom: AppDimens.sm),
                      child: ArticleCard(article: a),
                    )),
                if (state.hasMore)
                  _SeeMoreButton(
                    loading: state.loadingMore,
                    onTap: () => bloc.add(const ArticlesLoadMore()),
                  ),
              ],
            ),
          );
        }

        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildSection(Widget child) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section header
        Padding(
          padding: const EdgeInsets.fromLTRB(
              AppDimens.lg, AppDimens.xl, AppDimens.lg, AppDimens.sm),
          child: Text(
            title,
            style: const TextStyle(
              color: UiConstants.subtitleTextColor,
              fontSize: AppDimens.fCaption,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.8,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppDimens.lg),
          child: child,
        ),
      ],
    );
  }

  Widget _shimmerList() {
    return Column(
      children: List.generate(
        3,
        (_) => Padding(
          padding: const EdgeInsets.only(bottom: AppDimens.sm),
          child: Container(
            height: 140,
            decoration: BoxDecoration(
              color: UiConstants.infoBackgroundColor,
              borderRadius: AppDimens.brMd,
            ),
          ),
        ),
      ),
    );
  }
}

// ── "See more" button ───────────────────────────────────────────────────────────

class _SeeMoreButton extends StatelessWidget {
  final bool loading;
  final VoidCallback onTap;

  const _SeeMoreButton({required this.loading, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: AppDimens.xs, bottom: AppDimens.sm),
      child: GestureDetector(
        onTap: loading ? null : onTap,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: AppDimens.sm + 2),
          decoration: BoxDecoration(
            color: UiConstants.infoBackgroundColor,
            borderRadius: AppDimens.brMd,
            border: Border.all(
                color:
                    UiConstants.primaryButtonColor.withValues(alpha: 0.30)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (loading) ...[
                const BrandedLoader.small(),
                const SizedBox(width: AppDimens.sm),
                const Text(
                  'Loading…',
                  style: TextStyle(
                    color: UiConstants.primaryButtonColor,
                    fontSize: AppDimens.fCaption,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ] else ...[
                const Icon(Icons.expand_more_rounded,
                    size: 18, color: UiConstants.primaryButtonColor),
                const SizedBox(width: 6),
                const Text(
                  'See more articles',
                  style: TextStyle(
                    color: UiConstants.primaryButtonColor,
                    fontSize: AppDimens.fCaption,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
