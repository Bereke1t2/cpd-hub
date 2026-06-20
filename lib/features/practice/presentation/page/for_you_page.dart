import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lab_portal/core/di/injection.dart';
import 'package:lab_portal/core/theme/app_spacing.dart';
import 'package:lab_portal/core/theme/app_text_styles.dart';
import 'package:lab_portal/core/ui_constants.dart';
import 'package:lab_portal/core/widgets/async_view.dart';
import 'package:lab_portal/core/widgets/ui_kit.dart';
import 'package:lab_portal/features/learning/presentation/bloc/topics/topics_bloc.dart';
import 'package:lab_portal/future/main/domain/entity/problem_entity.dart';
import 'package:lab_portal/future/main/presentation/bloc/problems/problems_bloc.dart';
import 'package:lab_portal/future/main/presentation/page/base_page.dart';
import 'package:lab_portal/future/main/presentation/page/problem_details_page.dart';
import '../../domain/entity/upsolve_item_entity.dart';
import '../bloc/practice/practice_bloc.dart';
import '../widget/recommendation_card.dart';
import '../widget/review_tile.dart';

class ForYouPage extends StatelessWidget {
  const ForYouPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => getIt<TopicsBloc>()..add(const TopicsStarted()),
        ),
        BlocProvider(
          create: (_) => getIt<ProblemsBloc>()..add(ProblemsStarted()),
        ),
        BlocProvider(create: (_) => getIt<PracticeBloc>()),
      ],
      child: Builder(builder: (context) {
        // Wire topic context into PracticeBloc once TopicsBloc loads.
        return BlocListener<TopicsBloc, TopicsState>(
          listener: (ctx, topicsState) {
            if (topicsState is TopicsLoaded) {
              final solvedIds = topicsState.topics
                  .expand((t) => t.problemIds)
                  .where((id) {
                final problemsState = ctx.read<ProblemsBloc>().state;
                if (problemsState is ProblemsLoaded) {
                  try {
                    return problemsState.problems
                        .firstWhere((p) => p.problemId == id)
                        .isSolved;
                  } catch (_) {
                    return false;
                  }
                }
                return false;
              }).toSet();

              ctx.read<PracticeBloc>()
                ..setTopicContext(
                  topicsState.topics,
                  topicsState.progress,
                  solvedIds,
                )
                ..add(const PracticeStarted());
            }
          },
          child: BasePage(
            title: 'For You',
            subtitle: 'Personalised practice',
            selectedIndex: 1,
            body: BlocBuilder<PracticeBloc, PracticeState>(
              builder: (context, state) =>
                  BlocBuilder<ProblemsBloc, ProblemsState>(
                builder: (context, problemsState) {
                  final problems = problemsState is ProblemsLoaded
                      ? problemsState.problems
                      : <ProblemEntity>[];

                  return AsyncView<PracticeLoaded>(
                    isLoading: state is PracticeLoading ||
                        state is PracticeInitial,
                    error:
                        state is PracticeError ? state.message : null,
                    data: state is PracticeLoaded ? state : null,
                    onRetry: () => context
                        .read<PracticeBloc>()
                        .add(const PracticeStarted()),
                    emptyMessage: 'Nothing to practice right now',
                    emptySubtitle:
                        'Solve some problems to unlock recommendations.',
                    builder: (loaded) => _Body(
                      loaded: loaded,
                      problems: problems,
                    ),
                  );
                },
              ),
            ),
          ),
        );
      }),
    );
  }
}

class _Body extends StatelessWidget {
  final PracticeLoaded loaded;
  final List<ProblemEntity> problems;

  const _Body({required this.loaded, required this.problems});

  ProblemEntity? _problem(String id) {
    try {
      return problems.firstWhere((p) => p.problemId == id);
    } catch (_) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md, vertical: AppSpacing.sm),
      children: [
        // ── Recommendations ─────────────────────────────────────────────
        if (loaded.recommendations.isNotEmpty) ...[
          SectionHeader(
            'Recommended for you',
            icon: Icons.auto_awesome_rounded,
            trailing: '${loaded.recommendations.length}',
          ),
          const SizedBox(height: AppSpacing.xs),
          ...loaded.recommendations.map((rec) {
            final problem = _problem(rec.problemId);
            return Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.xs),
              child: RecommendationCard(
                rec: rec,
                onTap: () {
                  if (problem != null) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            ProblemDetailsPage(problem: problem),
                      ),
                    );
                  }
                },
                onAddToReview: () => context
                    .read<PracticeBloc>()
                    .add(PracticeAddToReview(rec.problemId)),
              ),
            );
          }),
          const SizedBox(height: AppSpacing.sm),
        ],

        // ── Due reviews ─────────────────────────────────────────────────
        if (loaded.dueReviews.isNotEmpty) ...[
          SectionHeader(
            'Due for review',
            icon: Icons.refresh_rounded,
            accent: UiConstants.ratingTextColor,
            trailing: '${loaded.dueReviews.length}',
          ),
          const SizedBox(height: AppSpacing.xs),
          ...loaded.dueReviews.map((item) {
            final problem = _problem(item.problemId);
            final title = problem?.title ??
                item.problemId
                    .replaceAll('-', ' ')
                    .split(' ')
                    .map((w) => w.isEmpty
                        ? ''
                        : '${w[0].toUpperCase()}${w.substring(1)}')
                    .join(' ');
            return Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.xs),
              child: ReviewTile(
                item: item,
                problemTitle: title,
                onTap: () {
                  if (problem != null) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            ProblemDetailsPage(problem: problem),
                      ),
                    );
                  }
                },
                onGotIt: () => context.read<PracticeBloc>().add(
                      PracticeReviewCompleted(item, recalled: true),
                    ),
                onForgot: () => context.read<PracticeBloc>().add(
                      PracticeReviewCompleted(item, recalled: false),
                    ),
              ),
            );
          }),
          const SizedBox(height: AppSpacing.sm),
        ],

        // ── Upsolves ────────────────────────────────────────────────────
        if (loaded.pendingUpsolves.isNotEmpty) ...[
          SectionHeader(
            'Upsolve',
            icon: Icons.emoji_events_outlined,
            accent: UiConstants.problemTextColor,
            trailing: '${loaded.pendingUpsolves.length} pending',
          ),
          const SizedBox(height: AppSpacing.xs),
          ...loaded.pendingUpsolves.map(
            (u) => Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.xs),
              child: _UpsolveRow(
                item: u,
                problem: _problem(u.problemId),
                onResolved: () => context
                    .read<PracticeBloc>()
                    .add(PracticeUpsolveResolved(u)),
              ),
            ),
          ),
        ],

        // ── Fallback when nothing due ────────────────────────────────────
        if (loaded.isEmpty)
          GradientCard(
            child: Column(
              children: [
                const Icon(Icons.check_circle_rounded,
                    size: 48, color: UiConstants.primaryButtonColor),
                const SizedBox(height: AppSpacing.sm),
                Text('All caught up!', style: AppTextStyles.title),
                const SizedBox(height: 4),
                const Text(
                  'Solve more problems to unlock recommendations and reviews.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: UiConstants.subtitleTextColor),
                ),
              ],
            ),
          ),

        const SizedBox(height: AppSpacing.xl),
      ],
    );
  }
}

class _UpsolveRow extends StatelessWidget {
  final UpsolveItemEntity item;
  final ProblemEntity? problem;
  final VoidCallback onResolved;

  const _UpsolveRow({
    required this.item,
    required this.problem,
    required this.onResolved,
  });

  @override
  Widget build(BuildContext context) {
    return GradientCard(
      accent: UiConstants.problemTextColor,
      child: Row(
        children: [
          const Icon(Icons.assignment_late_outlined,
              color: UiConstants.problemTextColor, size: 20),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.problemTitle, style: AppTextStyles.title,
                    maxLines: 1, overflow: TextOverflow.ellipsis),
                Text(item.contestTitle, style: AppTextStyles.caption),
              ],
            ),
          ),
          if (problem != null)
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ProblemDetailsPage(problem: problem!),
                  ),
                ).then((_) {
                  if (problem!.isSolved) onResolved();
                });
              },
              child: const Text('Solve',
                  style: TextStyle(color: UiConstants.primaryButtonColor)),
            ),
        ],
      ),
    );
  }
}
