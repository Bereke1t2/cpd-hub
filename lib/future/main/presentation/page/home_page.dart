import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lab_portal/core/di/injection.dart';
import 'package:lab_portal/core/routing/route_names.dart';
import 'package:lab_portal/core/theme/app_colors.dart';
import 'package:lab_portal/core/theme/app_dimens.dart';
import 'package:lab_portal/core/theme/app_text_styles.dart';
import 'package:lab_portal/core/ui_constants.dart';
import 'package:lab_portal/core/widgets/app_card.dart';
import 'package:lab_portal/core/widgets/app_chip.dart';
import 'package:lab_portal/core/widgets/app_text.dart';
import 'package:lab_portal/core/widgets/async_view.dart';
import 'package:lab_portal/core/widgets/avatar.dart';
import 'package:lab_portal/features/auth/presentation/bloc/session/session_bloc.dart';
import 'package:lab_portal/features/consistency/presentation/cubit/goals/goals_cubit.dart';
import 'package:lab_portal/features/consistency/presentation/cubit/streak/streak_cubit.dart';
import 'package:lab_portal/features/consistency/presentation/widget/goal_bar.dart';
import 'package:lab_portal/features/learning/domain/entity/topic_entity.dart';
import 'package:lab_portal/features/learning/domain/service/learning_path_engine.dart';
import 'package:lab_portal/features/learning/presentation/bloc/topics/topics_bloc.dart';
import 'package:lab_portal/features/learning/presentation/page/topic_detail_page.dart';
import 'package:lab_portal/future/main/domain/entity/contest_entity.dart';
import 'package:lab_portal/future/main/domain/entity/daily_problem_entity.dart';
import 'package:lab_portal/future/main/domain/entity/problem_entity.dart';
import 'package:lab_portal/future/main/presentation/bloc/contests/contests_bloc.dart';
import 'package:lab_portal/future/main/presentation/bloc/daily_problem/daily_problem_bloc.dart';
import 'package:lab_portal/future/main/presentation/bloc/problems/problems_bloc.dart';
import 'package:lab_portal/future/main/presentation/widget/countdown_timer.dart';
import 'package:lab_portal/future/main/presentation/widget/liked_and_dis_button.dart';

import 'base_page.dart';

// ── Static topic categories ───────────────────────────────────────────────────
class _Cat {
  final String label;
  final IconData icon;
  const _Cat(this.label, this.icon);
}

const _kCats = [
  _Cat('Algorithms', Icons.account_tree_outlined),
  _Cat('Data Structures', Icons.storage_outlined),
  _Cat('Graphs', Icons.hub_outlined),
  _Cat('Dynamic\nProgramming', Icons.layers_outlined),
  _Cat('Strings', Icons.text_fields_outlined),
  _Cat('Sorting', Icons.sort_rounded),
];

// ─────────────────────────────────────────────────────────────────────────────

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final StreakCubit _streakCubit;
  late final GoalsCubit _goalsCubit;
  late final DailyProblemBloc _dailyProblemBloc;
  late final ProblemsBloc _problemsBloc;
  late final TopicsBloc _topicsBloc;
  late final ContestsBloc _contestsBloc;

  @override
  void initState() {
    super.initState();
    _streakCubit = getIt<StreakCubit>()..load();
    _goalsCubit = getIt<GoalsCubit>()..load();
    _dailyProblemBloc = getIt<DailyProblemBloc>();
    _problemsBloc = getIt<ProblemsBloc>();
    _topicsBloc = getIt<TopicsBloc>();
    _contestsBloc = getIt<ContestsBloc>();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _dailyProblemBloc.add(DailyProblemStarted());
      _problemsBloc.add(ProblemsStarted());
      _contestsBloc.add(ContestsStarted());
      _topicsBloc.add(const TopicsStarted());
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: _dailyProblemBloc),
        BlocProvider.value(value: _problemsBloc),
        BlocProvider.value(value: _topicsBloc),
        BlocProvider.value(value: _contestsBloc),
        BlocProvider.value(value: _streakCubit),
        BlocProvider.value(value: _goalsCubit),
      ],
      child: BlocBuilder<SessionBloc, SessionState>(
        builder: (context, sessionState) {
          final name = sessionState is SessionAuthenticated
              ? sessionState.user.fullName
              : '';
          final initials = _initials(name);

          return BasePage(
            selectedIndex: 0,
            title: name.isEmpty ? 'Home' : 'Hi, ${name.split(' ').first} 👋',
            subtitle: 'Ready to solve today?',
            appBarTrailing: Avatar(
              initials: initials,
              color: Colors.white,
              size: AppDimens.avatarMd,
            ),
            body: CustomScrollView(
              slivers: [
                // ── Search bar ─────────────────────────────────────────────
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(
                        AppDimens.lg, AppDimens.md, AppDimens.lg, 0),
                    child: GestureDetector(
                      onTap: () =>
                          Navigator.pushNamed(context, RouteNames.problems),
                      child: Container(
                        height: 46,
                        padding: const EdgeInsets.symmetric(
                            horizontal: AppDimens.md),
                        decoration: BoxDecoration(
                          color: UiConstants.infoBackgroundColor,
                          borderRadius: const BorderRadius.all(
                              Radius.circular(AppDimens.rPill)),
                          border: Border.all(
                              color: UiConstants.primaryButtonColor
                                  .withValues(alpha: 0.25)),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.search_rounded,
                                color: UiConstants.primaryButtonColor,
                                size: AppDimens.iconMd),
                            const SizedBox(width: AppDimens.sm),
                            AppText.body('Search problems, topics…',
                                color: UiConstants.subtitleTextColor),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

                // ── Streak hero banner ─────────────────────────────────────
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(
                        AppDimens.lg, AppDimens.lg, AppDimens.lg, 0),
                    child: BlocBuilder<StreakCubit, StreakState>(
                      builder: (context, state) {
                        final streak = state is StreakLoaded
                            ? state.streak.current
                            : 0;
                        final weekRatio = state is StreakLoaded
                            ? state.streak.weekRatio
                            : 0.0;
                        return GestureDetector(
                          onTap: () => Navigator.pushNamed(
                              context, RouteNames.consistency),
                          child: Container(
                            padding: const EdgeInsets.all(AppDimens.lg),
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [
                                  UiConstants.primaryButtonColor,
                                  UiConstants.primaryDark,
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: AppDimens.brLg,
                              boxShadow: [
                                BoxShadow(
                                  color: UiConstants.primaryButtonColor
                                      .withValues(alpha: 0.30),
                                  blurRadius: 18,
                                  offset: const Offset(0, 8),
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'KEEP YOUR STREAK GOING',
                                        style: TextStyle(
                                          color: Colors.white70,
                                          fontSize: AppDimens.fCaption,
                                          fontWeight: FontWeight.w800,
                                          letterSpacing: 0.8,
                                        ),
                                      ),
                                      const SizedBox(height: AppDimens.xs),
                                      Text(
                                        '$streak day${streak == 1 ? '' : 's'} streak 🔥',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: AppDimens.fH1,
                                          fontWeight: FontWeight.w900,
                                        ),
                                      ),
                                      const SizedBox(height: AppDimens.sm),
                                      ClipRRect(
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(AppDimens.rPill)),
                                        child: LinearProgressIndicator(
                                          value: weekRatio.clamp(0.0, 1.0),
                                          minHeight: 6,
                                          backgroundColor: Colors.white
                                              .withValues(alpha: 0.25),
                                          valueColor:
                                              const AlwaysStoppedAnimation<
                                                  Color>(Colors.white),
                                        ),
                                      ),
                                      const SizedBox(height: AppDimens.xs),
                                      Text(
                                        '${(weekRatio * 7).round()}/7 days this week',
                                        style: const TextStyle(
                                          color: Colors.white70,
                                          fontSize: AppDimens.fCaption,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: AppDimens.lg),
                                Container(
                                  width: 60,
                                  height: 60,
                                  decoration: BoxDecoration(
                                    color:
                                        Colors.white.withValues(alpha: 0.18),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.local_fire_department_rounded,
                                    color: Colors.white,
                                    size: 34,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),

                // ── Upcoming Contests ──────────────────────────────────────
                SliverToBoxAdapter(
                  child: _UpcomingContestsSection(),
                ),

                // ── Browse Topics ──────────────────────────────────────────
                SliverToBoxAdapter(
                  child: _SectionHeader(
                    label: 'BROWSE TOPICS',
                    onViewAll: () =>
                        Navigator.pushNamed(context, RouteNames.learn),
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: AppDimens.lg),
                  sliver: SliverGrid(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: AppDimens.sm,
                      crossAxisSpacing: AppDimens.sm,
                      childAspectRatio: 2.8,
                    ),
                    delegate: SliverChildBuilderDelegate(
                      (context, i) {
                        final cat = _kCats[i];
                        return GestureDetector(
                          onTap: () => Navigator.pushNamed(
                              context, RouteNames.learn),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: AppDimens.md,
                                vertical: AppDimens.sm),
                            decoration: BoxDecoration(
                              color: UiConstants.infoBackgroundColor,
                              borderRadius: AppDimens.brMd,
                              border: Border.all(
                                  color: UiConstants.primaryButtonColor
                                      .withValues(alpha: 0.18)),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 34,
                                  height: 34,
                                  decoration: BoxDecoration(
                                    color: UiConstants.primaryButtonColor
                                        .withValues(alpha: 0.15),
                                    borderRadius: AppDimens.brSm,
                                  ),
                                  child: Icon(cat.icon,
                                      color: UiConstants.primaryButtonColor,
                                      size: AppDimens.iconSm),
                                ),
                                const SizedBox(width: AppDimens.sm),
                                Expanded(
                                  child: Text(
                                    cat.label,
                                    style: const TextStyle(
                                      color: UiConstants.mainTextColor,
                                      fontSize: AppDimens.fCaption,
                                      fontWeight: FontWeight.w700,
                                      height: 1.25,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                const Icon(Icons.chevron_right_rounded,
                                    size: AppDimens.iconSm,
                                    color: UiConstants.subtitleTextColor),
                              ],
                            ),
                          ),
                        );
                      },
                      childCount: _kCats.length,
                    ),
                  ),
                ),

                // ── Today's Problem ────────────────────────────────────────
                SliverToBoxAdapter(
                  child: _SectionHeader(label: "TODAY'S CHALLENGE"),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: AppDimens.lg),
                    child:
                        BlocBuilder<DailyProblemBloc, DailyProblemState>(
                      builder: (context, state) {
                        if (state is DailyProblemLoading ||
                            state is DailyProblemInitial) {
                          return const _Shimmer(height: 100);
                        }
                        if (state is! DailyProblemLoaded) {
                          return const SizedBox.shrink();
                        }
                        final d = state.daily;
                        return _DailyCard(daily: d);
                      },
                    ),
                  ),
                ),

                // ── Popular Problems ───────────────────────────────────────
                SliverToBoxAdapter(
                  child: _SectionHeader(
                    label: 'POPULAR PROBLEMS',
                    onViewAll: () =>
                        Navigator.pushNamed(context, RouteNames.problems),
                  ),
                ),
                SliverToBoxAdapter(
                  child: SizedBox(
                    height: 148,
                    child: BlocBuilder<ProblemsBloc, ProblemsState>(
                      builder: (context, state) {
                        if (state is ProblemsLoading ||
                            state is ProblemsInitial) {
                          return _shimmerHList();
                        }
                        if (state is! ProblemsLoaded) {
                          return const SizedBox.shrink();
                        }
                        final problems = state.problems.take(8).toList();
                        return ListView.builder(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.symmetric(
                              horizontal: AppDimens.lg),
                          itemCount: problems.length,
                          itemBuilder: (context, i) => RepaintBoundary(
                            child: _ProblemHCard(
                              problem: problems[i],
                              onTap: () => Navigator.pushNamed(
                                  context, RouteNames.problems),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),

                // ── Continue Learning ──────────────────────────────────────
                SliverToBoxAdapter(
                  child: _ContinueLearningSection(),
                ),

                // ── Goal bar ───────────────────────────────────────────────
                SliverToBoxAdapter(
                  child: BlocBuilder<GoalsCubit, GoalsState>(
                    builder: (context, state) {
                      if (state is! GoalsLoaded) return const SizedBox.shrink();
                      final g = state.goal;
                      return Padding(
                        padding: const EdgeInsets.fromLTRB(AppDimens.lg,
                            AppDimens.md, AppDimens.lg, 0),
                        child: GestureDetector(
                          onTap: () => Navigator.pushNamed(
                              context, RouteNames.consistency),
                          child: GoalBar(
                            label: g.label,
                            progress: g.progress,
                            target: g.target,
                          ),
                        ),
                      );
                    },
                  ),
                ),

                const SliverToBoxAdapter(
                    child: SizedBox(height: AppDimens.xl + 80)),
              ],
            ),
          );
        },
      ),
    );
  }

  String _initials(String name) {
    if (name.isEmpty) return 'U';
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.length >= 2) {
      return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
    }
    return name.substring(0, name.length.clamp(1, 2)).toUpperCase();
  }

  Widget _shimmerHList() {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: AppDimens.lg),
      itemCount: 4,
      itemBuilder: (_, __) => const Padding(
        padding: EdgeInsets.only(right: AppDimens.md),
        child: _Shimmer(width: 148, height: 140),
      ),
    );
  }
}

// ── Upcoming contests section ─────────────────────────────────────────────────
class _UpcomingContestsSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ContestsBloc, ContestsState>(
      builder: (context, state) {
        if (state is! ContestsLoaded) return const SizedBox.shrink();
        final upcoming = state.all
            .where((c) => c.isUpcoming)
            .toList()
          ..sort((a, b) => a.startsAt.compareTo(b.startsAt));
        if (upcoming.isEmpty) return const SizedBox.shrink();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _SectionHeader(
              label: 'UPCOMING CONTESTS',
              onViewAll: () =>
                  Navigator.pushNamed(context, RouteNames.contests),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppDimens.lg),
              child: Column(
                children: upcoming
                    .take(3)
                    .map((c) => Padding(
                          padding:
                              const EdgeInsets.only(bottom: AppDimens.sm),
                          child: _ContestCountdownTile(contest: c),
                        ))
                    .toList(),
              ),
            ),
          ],
        );
      },
    );
  }
}

/// A single contest tile showing a live (red) or upcoming (green) countdown.
class _ContestCountdownTile extends StatefulWidget {
  final ContestEntity contest;
  const _ContestCountdownTile({required this.contest});

  @override
  State<_ContestCountdownTile> createState() => _ContestCountdownTileState();
}

class _ContestCountdownTileState extends State<_ContestCountdownTile> {
  bool _isLive = false;

  @override
  Widget build(BuildContext context) {
    // Green = not started yet. Red = contest is running / elapsed start time.
    final accent =
        _isLive ? const Color(0xFFE53935) : UiConstants.primaryButtonColor;

    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, RouteNames.contests),
      child: Container(
        padding: const EdgeInsets.symmetric(
            horizontal: AppDimens.md, vertical: AppDimens.sm + 2),
        decoration: BoxDecoration(
          color: UiConstants.infoBackgroundColor,
          borderRadius: AppDimens.brMd,
          border: Border.all(color: accent.withValues(alpha: 0.30)),
        ),
        child: Row(
          children: [
            // Pulsing status dot
            Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: accent,
                boxShadow: [
                  BoxShadow(
                      color: accent.withValues(alpha: 0.55),
                      blurRadius: 6),
                ],
              ),
            ),
            const SizedBox(width: AppDimens.sm),
            // Platform chip
            AppChip(
              widget.contest.platform,
              color: accent,
            ),
            const SizedBox(width: AppDimens.sm),
            // Title
            Expanded(
              child: AppText.body(
                widget.contest.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: AppDimens.sm),
            // Countdown or LIVE badge
            if (_isLive)
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: AppDimens.sm, vertical: AppDimens.xs),
                decoration: BoxDecoration(
                  color: const Color(0xFFE53935).withValues(alpha: 0.15),
                  borderRadius: AppDimens.brSm,
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.circle,
                        size: 8, color: Color(0xFFE53935)),
                    SizedBox(width: 4),
                    Text(
                      'LIVE',
                      style: TextStyle(
                        color: Color(0xFFE53935),
                        fontSize: AppDimens.fCaption,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              )
            else
              CountdownTimer(
                target: widget.contest.startsAt,
                onElapsed: () => setState(() => _isLive = true),
              ),
          ],
        ),
      ),
    );
  }
}

// ── Daily problem card ────────────────────────────────────────────────────────
class _DailyCard extends StatelessWidget {
  final DailyProblemEntity daily;
  const _DailyCard({required this.daily});

  @override
  Widget build(BuildContext context) {
    final diffColor = AppColors.difficulty(daily.difficulty);
    return AppCard(
      accent: diffColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                  child: AppText.title(daily.title,
                      maxLines: 2, overflow: TextOverflow.ellipsis)),
              const SizedBox(width: AppDimens.sm),
              AppChip(daily.difficulty,
                  color: diffColor,
                  backgroundColor: AppColors.difficultyBg(daily.difficulty)),
            ],
          ),
          if (daily.tags.isNotEmpty) ...[
            const SizedBox(height: AppDimens.sm),
            Wrap(
              spacing: AppDimens.xs,
              runSpacing: AppDimens.xs,
              children: daily.tags
                  .take(4)
                  .map((t) => AppChip(t,
                      color: UiConstants.primaryButtonColor,
                      backgroundColor:
                          UiConstants.primaryButtonColor.withValues(alpha: 0.10)))
                  .toList(),
            ),
          ],
          const SizedBox(height: AppDimens.sm),
          Row(
            children: [
              AppText.caption('${daily.numberOfSolvedPeople} solved',
                  color: UiConstants.primaryButtonColor),
              const Spacer(),
              LikedAndDislikedButtons(
                isLiked: daily.isLiked,
                isDisliked: daily.isDisliked,
                likedCount: daily.numberOfLikes,
                dislikedCount: daily.numberOfDislikes,
                onLike: () {},
                onDislike: () {},
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ── Popular Problems horizontal card ─────────────────────────────────────────
class _ProblemHCard extends StatelessWidget {
  final ProblemEntity problem;
  final VoidCallback? onTap;
  const _ProblemHCard({required this.problem, this.onTap});

  @override
  Widget build(BuildContext context) {
    final diffColor = AppColors.difficulty(problem.difficulty);
    final diffBg = AppColors.difficultyBg(problem.difficulty);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 148,
        margin: const EdgeInsets.only(right: AppDimens.md),
        padding: const EdgeInsets.all(AppDimens.md),
        decoration: BoxDecoration(
          color: UiConstants.infoBackgroundColor,
          borderRadius: AppDimens.brMd,
          border:
              Border.all(color: UiConstants.primaryButtonColor.withValues(alpha: 0.18)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 34,
              height: 34,
              decoration:
                  BoxDecoration(color: diffBg, borderRadius: AppDimens.brSm),
              child: Center(
                child: Text(
                  problem.difficulty[0].toUpperCase(),
                  style: TextStyle(
                      color: diffColor,
                      fontSize: AppDimens.fTitle,
                      fontWeight: FontWeight.w900),
                ),
              ),
            ),
            const SizedBox(height: AppDimens.sm),
            Expanded(
              child: Text(
                problem.title,
                style: const TextStyle(
                  color: UiConstants.mainTextColor,
                  fontSize: AppDimens.fCaption,
                  fontWeight: FontWeight.w700,
                  height: 1.3,
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(height: AppDimens.xs),
            Row(
              children: [
                const Icon(Icons.people_outline,
                    size: 11, color: UiConstants.subtitleTextColor),
                const SizedBox(width: 3),
                Flexible(
                  child: Text(
                    '${problem.numberOfSolvedPeople}',
                    style: const TextStyle(
                        color: UiConstants.subtitleTextColor,
                        fontSize: AppDimens.fMicro),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ── Continue Learning section ─────────────────────────────────────────────────
class _ContinueLearningSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TopicsBloc, TopicsState>(
      builder: (context, state) {
        if (state is! TopicsLoaded) return const SizedBox.shrink();
        final frontier = state.frontier;
        if (frontier.isEmpty) return const SizedBox.shrink();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _SectionHeader(
              label: 'CONTINUE LEARNING',
              onViewAll: () =>
                  Navigator.pushNamed(context, RouteNames.learn),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppDimens.lg),
              child: Column(
                children: frontier.take(3).map((topic) {
                  final progress = state.progress[topic.id]!;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: AppDimens.sm),
                    child: _FrontierTile(
                      topic: topic,
                      progress: progress,
                      allProgress: state.progress,
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _FrontierTile extends StatelessWidget {
  final TopicEntity topic;
  final TopicProgress progress;
  final Map<String, TopicProgress> allProgress;
  const _FrontierTile(
      {required this.topic,
      required this.progress,
      required this.allProgress});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => TopicDetailPage(
              topic: topic, progress: progress, allProgress: allProgress),
        ),
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(
            horizontal: AppDimens.md, vertical: AppDimens.sm + 2),
        decoration: BoxDecoration(
          color: UiConstants.infoBackgroundColor,
          borderRadius: AppDimens.brMd,
          border: Border.all(
              color:
                  UiConstants.primaryButtonColor.withValues(alpha: 0.16)),
        ),
        child: Row(
          children: [
            Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                color: UiConstants.primaryButtonColor.withValues(alpha: 0.12),
                borderRadius: AppDimens.brSm,
              ),
              child: const Icon(Icons.play_circle_fill_rounded,
                  size: AppDimens.iconSm,
                  color: UiConstants.primaryButtonColor),
            ),
            const SizedBox(width: AppDimens.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(topic.name,
                      style: AppTextStyles.body,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis),
                  Text(topic.category, style: AppTextStyles.caption),
                ],
              ),
            ),
            const Icon(Icons.chevron_right_rounded,
                size: AppDimens.iconSm,
                color: UiConstants.subtitleTextColor),
          ],
        ),
      ),
    );
  }
}

// ── Helpers ───────────────────────────────────────────────────────────────────
class _SectionHeader extends StatelessWidget {
  final String label;
  final VoidCallback? onViewAll;
  const _SectionHeader({required this.label, this.onViewAll});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
          AppDimens.lg, AppDimens.xl, AppDimens.lg, AppDimens.sm),
      child: Row(
        children: [
          Text(
            label,
            style: const TextStyle(
              color: UiConstants.subtitleTextColor,
              fontSize: AppDimens.fCaption,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.8,
            ),
          ),
          if (onViewAll != null) ...[
            const Spacer(),
            GestureDetector(
              onTap: onViewAll,
              child: const Text(
                'View all',
                style: TextStyle(
                  color: UiConstants.primaryButtonColor,
                  fontSize: AppDimens.fCaption,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _Shimmer extends StatelessWidget {
  final double? width;
  final double height;
  const _Shimmer({this.width, required this.height});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: UiConstants.infoBackgroundColor,
        borderRadius: AppDimens.brMd,
      ),
    );
  }
}
