import 'package:flutter/material.dart';
import 'package:lab_portal/core/routing/route_names.dart';
import 'package:lab_portal/core/theme/app_spacing.dart';
import 'package:lab_portal/core/theme/app_text_styles.dart';
import 'package:lab_portal/core/ui_constants.dart';
import 'package:lab_portal/core/widgets/ui_kit.dart';
import 'package:lab_portal/features/consistency/presentation/cubit/goals/goals_cubit.dart';
import 'package:lab_portal/features/consistency/presentation/cubit/streak/streak_cubit.dart';
import 'package:lab_portal/features/consistency/presentation/widget/goal_bar.dart';
import 'package:lab_portal/features/consistency/presentation/widget/streak_ring.dart';
import 'package:lab_portal/features/learning/domain/entity/topic_entity.dart';
import 'package:lab_portal/features/learning/domain/service/learning_path_engine.dart';
import 'package:lab_portal/features/learning/presentation/bloc/topics/topics_bloc.dart';
import 'package:lab_portal/features/learning/presentation/page/topic_detail_page.dart';
import 'package:lab_portal/future/main/presentation/widget/problem_box.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lab_portal/core/widgets/async_view.dart';
import 'package:lab_portal/future/main/domain/entity/daily_problem_entity.dart';
import 'package:lab_portal/future/main/presentation/bloc/daily_problem/daily_problem_bloc.dart';
import 'package:lab_portal/future/main/presentation/bloc/problems/problems_bloc.dart';
import 'package:lab_portal/core/di/injection.dart';
import 'package:lab_portal/features/auth/presentation/bloc/session/session_bloc.dart';

import '../widget/info_box.dart';
import '../widget/todays_problem_box.dart';
import '../widget/welcomback_box.dart';
import 'base_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) =>
              getIt<DailyProblemBloc>()..add(DailyProblemStarted()),
        ),
        BlocProvider(
          create: (_) => getIt<ProblemsBloc>()..add(ProblemsStarted()),
        ),
        BlocProvider(
          create: (_) => getIt<TopicsBloc>()..add(const TopicsStarted()),
        ),
        BlocProvider.value(value: getIt<StreakCubit>()..load()),
        BlocProvider.value(value: getIt<GoalsCubit>()..load()),
      ],
      child: BasePage(
        selectedIndex: 0,
        title: 'Home',
        subtitle: 'Ready to solve today?',
        body: SingleChildScrollView(
          child: Column(
            children: [
              BlocBuilder<SessionBloc, SessionState>(
                builder: (context, state) {
                  final name = state is SessionAuthenticated
                      ? state.user.fullName
                      : '';
                  return WelcomeBackBox(name: name);
                },
              ),
              const _ConsistencyHub(),
              const _ContinueLearningCard(),
              const _ForYouEntryCard(),
              const InfoBox(
                title: 'Problem Solving',
                description: 'Let\'s tackle today\'s challenges together!',
              ),
              const InfoBox(
                title: 'Todays Contest',
                description:
                    'Join the contest and test your skills against others!... to participate, click the button below. follow this 3 rules: 1. No plagiarism 2. No external help 3. Submit within the time limit',
              ),
              BlocBuilder<DailyProblemBloc, DailyProblemState>(
                builder: (context, state) => AsyncView<DailyProblemEntity>(
                  isLoading: state is DailyProblemLoading || state is DailyProblemInitial,
                  error: state is DailyProblemError ? state.message : null,
                  data: state is DailyProblemLoaded ? state.daily : null,
                  onRetry: () => context.read<DailyProblemBloc>().add(DailyProblemStarted()),
                  emptyMessage: 'No daily problem today',
                  builder: (daily) => TodaysProblemBox(
                    problemTitle: daily.title,
                    solved: daily.numberOfSolvedPeople.toDouble(),
                    tags: daily.tags,
                    liked: daily.numberOfLikes.toDouble(),
                    disliked: daily.numberOfDislikes.toDouble(),
                    difficulty: daily.difficulty,
                    isLiked: daily.isLiked,
                    isDisliked: daily.isDisliked,
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 12.0),
                width: double.infinity,
                padding: const EdgeInsets.only(left: 0.0, top: 16),
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(12.0)),
                  color: UiConstants.infoBackgroundColor,
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Row(
                        children: [
                          Container(
                            margin: const EdgeInsets.only(left: 8.0),
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(6.0),
                                  decoration: BoxDecoration(
                                    color: UiConstants.primaryButtonColor
                                        .withOpacity(0.18),
                                    borderRadius: BorderRadius.circular(4.0),
                                  ),
                                  child: const Icon(
                                    Icons.grid_view,
                                    color: UiConstants.statTextColor,
                                    size: 20,
                                  ),
                                ),
                                const SizedBox(width: 12.0),
                                const Text(
                                  'All Problems',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: UiConstants.mainTextColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Spacer(),
                          Icon(
                            Icons.arrow_drop_down,
                            color: UiConstants.subtitleTextColor,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12.0),
                    BlocBuilder<ProblemsBloc, ProblemsState>(
                      builder: (context, state) => AsyncView<List>(
                        isLoading: state is ProblemsLoading || state is ProblemsInitial,
                        error: state is ProblemsError ? state.message : null,
                        data: state is ProblemsLoaded
                            ? state.problems.take(5).toList()
                            : null,
                        isEmpty: (d) => d.isEmpty,
                        onRetry: () => context.read<ProblemsBloc>().add(ProblemsStarted()),
                        emptyMessage: 'No problems yet',
                        builder: (problems) => ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: problems.length,
                          separatorBuilder: (_, __) => const SizedBox.shrink(),
                          itemBuilder: (context, index) {
                            final p = problems[index];
                            return ProblemBox(
                              title: p.title,
                              difficulty: p.difficulty,
                            );
                          },
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, '/problems');
                      },
                      child: Container(
                        width: double.infinity,
                        margin: const EdgeInsets.fromLTRB(12, 8, 12, 12),
                        padding: const EdgeInsets.symmetric(
                          vertical: 12.0,
                          horizontal: 16,
                        ),
                        decoration: BoxDecoration(
                          color:
                              UiConstants.primaryButtonColor.withOpacity(0.10),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Flexible(
                              child: Text(
                                'See more',
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: UiConstants.primaryButtonColor,
                                ),
                              ),
                            ),
                            const SizedBox(width: 6),
                            const Icon(
                              Icons.arrow_forward_rounded,
                              size: 18,
                              color: UiConstants.primaryButtonColor,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Live streak + weekly goal hub replacing the hardcoded StreakProgressBox.
class _ConsistencyHub extends StatelessWidget {
  const _ConsistencyHub();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm, vertical: AppSpacing.xs),
      child: Column(
        children: [
          BlocBuilder<StreakCubit, StreakState>(
            builder: (context, state) {
              if (state is! StreakLoaded) return const SizedBox.shrink();
              final s = state.streak;
              return GestureDetector(
                onTap: () =>
                    Navigator.pushNamed(context, RouteNames.consistency),
                child: StreakRing(
                  current: s.current,
                  longest: s.longest,
                  freezesAvailable: s.freezesAvailable,
                  weekRatio: s.weekRatio,
                ),
              );
            },
          ),
          const SizedBox(height: AppSpacing.xs),
          BlocBuilder<GoalsCubit, GoalsState>(
            builder: (context, state) {
              if (state is! GoalsLoaded) return const SizedBox.shrink();
              final g = state.goal;
              return GestureDetector(
                onTap: () =>
                    Navigator.pushNamed(context, RouteNames.consistency),
                child: GoalBar(
                  label: g.label,
                  progress: g.progress,
                  target: g.target,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

/// Entry card that navigates to /for-you.
class _ForYouEntryCard extends StatelessWidget {
  const _ForYouEntryCard();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm, vertical: AppSpacing.xxs),
      child: GradientCard(
        accent: UiConstants.problemTextColor,
        onTap: () => Navigator.pushNamed(context, RouteNames.forYou),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: UiConstants.problemTextColor.withOpacity(0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.auto_awesome_rounded,
                  color: UiConstants.problemTextColor, size: 20),
            ),
            const SizedBox(width: AppSpacing.sm),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('For You',
                      style: TextStyle(
                          color: UiConstants.mainTextColor,
                          fontWeight: FontWeight.w700,
                          fontSize: 15)),
                  Text('Recommendations, reviews & upsolves',
                      style: TextStyle(
                          color: UiConstants.subtitleTextColor, fontSize: 12)),
                ],
              ),
            ),
            const Icon(Icons.chevron_right_rounded,
                color: UiConstants.subtitleTextColor),
          ],
        ),
      ),
    );
  }
}

/// Compact "Continue Learning" card shown on Home.
/// Shows up to 3 available topics from TopicsBloc, with a "See all" link to
/// the full skill tree. Hidden when loading or when the frontier is empty.
class _ContinueLearningCard extends StatelessWidget {
  const _ContinueLearningCard();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TopicsBloc, TopicsState>(
      builder: (context, state) {
        if (state is! TopicsLoaded) return const SizedBox.shrink();
        final frontier = state.frontier;
        if (frontier.isEmpty) return const SizedBox.shrink();
        final shown = frontier.take(3).toList();

        return Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.sm, vertical: AppSpacing.xs),
          child: GradientCard(
            accent: UiConstants.ratingTextColor,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const SectionHeader(
                      'Continue Learning',
                      icon: Icons.school_rounded,
                      accent: UiConstants.ratingTextColor,
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: () => Navigator.pushNamed(
                          context, RouteNames.learn),
                      child: const Text(
                        'See all →',
                        style: TextStyle(
                          color: UiConstants.primaryButtonColor,
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.xs),
                for (final topic in shown)
                  _FrontierRow(
                    topic: topic,
                    progress: state.progress[topic.id]!,
                    allProgress: state.progress,
                  ),
                const SizedBox(height: AppSpacing.xxs),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _FrontierRow extends StatelessWidget {
  final TopicEntity topic;
  final TopicProgress progress;
  final Map<String, TopicProgress> allProgress;

  const _FrontierRow({
    required this.topic,
    required this.progress,
    required this.allProgress,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => TopicDetailPage(
            topic: topic,
            progress: progress,
            allProgress: allProgress,
          ),
        ),
      ),
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(
          children: [
            const Icon(Icons.play_circle_fill_rounded,
                size: 18, color: UiConstants.ratingTextColor),
            const SizedBox(width: AppSpacing.xs),
            Expanded(
              child: Text(topic.name, style: AppTextStyles.body),
            ),
            Text(
              topic.category,
              style: AppTextStyles.caption,
            ),
            const SizedBox(width: AppSpacing.xs),
            const Icon(Icons.chevron_right_rounded,
                size: 16, color: UiConstants.subtitleTextColor),
          ],
        ),
      ),
    );
  }
}