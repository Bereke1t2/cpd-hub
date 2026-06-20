import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lab_portal/core/di/injection.dart';
import 'package:lab_portal/core/theme/app_spacing.dart';
import 'package:lab_portal/core/theme/app_text_styles.dart';
import 'package:lab_portal/core/ui_constants.dart';
import 'package:lab_portal/core/widgets/async_view.dart';
import 'package:lab_portal/core/widgets/ui_kit.dart';
import 'package:lab_portal/future/main/domain/entity/problem_entity.dart';
import 'package:lab_portal/future/main/presentation/bloc/problems/problems_bloc.dart';
import 'package:lab_portal/future/main/presentation/page/base_page.dart';
import 'package:lab_portal/future/main/presentation/page/problem_details_page.dart';
import '../../domain/entity/ladder_entity.dart';
import '../bloc/ladder/ladder_bloc.dart';
import '../cubit/goals/goals_cubit.dart';
import '../cubit/streak/streak_cubit.dart';
import '../widget/goal_bar.dart';
import '../widget/ladder_rung_tile.dart';
import '../widget/streak_ring.dart';
import 'ladder_page.dart';

class ConsistencyPage extends StatelessWidget {
  const ConsistencyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => getIt<StreakCubit>()..load(),
        ),
        BlocProvider(
          create: (_) => getIt<GoalsCubit>()..load(),
        ),
        BlocProvider(
          create: (_) =>
              getIt<LadderBloc>()..add(const LadderStarted()),
        ),
        BlocProvider(
          create: (_) =>
              getIt<ProblemsBloc>()..add(ProblemsStarted()),
        ),
      ],
      child: BasePage(
        title: 'Consistency',
        subtitle: 'Build the habit, build the skill',
        selectedIndex: 0,
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
              vertical: AppSpacing.sm, horizontal: AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Streak ring ──────────────────────────────────────────
              BlocBuilder<StreakCubit, StreakState>(
                builder: (context, state) {
                  if (state is! StreakLoaded) return const SizedBox.shrink();
                  final s = state.streak;
                  return StreakRing(
                    current: s.current,
                    longest: s.longest,
                    freezesAvailable: s.freezesAvailable,
                    weekRatio: s.weekRatio,
                  );
                },
              ),
              const SizedBox(height: AppSpacing.sm),

              // ── Weekly goal ──────────────────────────────────────────
              BlocBuilder<GoalsCubit, GoalsState>(
                builder: (context, state) {
                  if (state is! GoalsLoaded) return const SizedBox.shrink();
                  final goal = state.goal;
                  return GoalBar(
                    label: goal.label,
                    progress: goal.progress,
                    target: goal.target,
                    onEditTap: () => _showEditGoal(context, goal.target),
                  );
                },
              ),
              const SizedBox(height: AppSpacing.sm),

              // ── Active ladder ────────────────────────────────────────
              BlocBuilder<LadderBloc, LadderState>(
                builder: (context, ladderState) =>
                    BlocBuilder<ProblemsBloc, ProblemsState>(
                  builder: (context, problemsState) {
                    final problems = problemsState is ProblemsLoaded
                        ? problemsState.problems
                        : <ProblemEntity>[];

                    return AsyncView<List<LadderEntity>>(
                      isLoading: ladderState is LadderLoading ||
                          ladderState is LadderInitial,
                      error: ladderState is LadderError
                          ? ladderState.message
                          : null,
                      data: ladderState is LadderLoaded
                          ? ladderState.ladders
                          : null,
                      onRetry: () =>
                          context.read<LadderBloc>().add(const LadderStarted()),
                      emptyMessage: 'No ladders available',
                      builder: (ladders) {
                        final state = ladderState as LadderLoaded;
                        final active = state.activeLadder;
                        if (active == null) {
                          return GradientCard(
                            child: Row(children: [
                              const Icon(Icons.emoji_events_rounded,
                                  color: UiConstants.primaryButtonColor),
                              const SizedBox(width: AppSpacing.sm),
                              Text('All ladders complete!',
                                  style: AppTextStyles.title),
                            ]),
                          );
                        }
                        return _LadderPreview(
                          ladder: active,
                          problems: problems,
                          onSeeAll: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => LadderPage(ladder: active),
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showEditGoal(BuildContext context, int currentTarget) {
    int value = currentTarget;
    showModalBottomSheet(
      context: context,
      backgroundColor: UiConstants.infoBackgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setState) => Padding(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Weekly goal', style: AppTextStyles.title),
              const SizedBox(height: AppSpacing.md),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: () => setState(() => value = (value - 1).clamp(1, 30)),
                    icon: const Icon(Icons.remove_circle_outline_rounded,
                        color: UiConstants.primaryButtonColor),
                  ),
                  Text('$value problems / week',
                      style: AppTextStyles.h2),
                  IconButton(
                    onPressed: () => setState(() => value = (value + 1).clamp(1, 30)),
                    icon: const Icon(Icons.add_circle_outline_rounded,
                        color: UiConstants.primaryButtonColor),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),
              FilledButton(
                style: FilledButton.styleFrom(
                  backgroundColor: UiConstants.primaryButtonColor,
                  minimumSize: const Size(double.infinity, 48),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  context.read<GoalsCubit>().updateTarget(value);
                  Navigator.pop(ctx);
                },
                child: const Text('Save',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.w700)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LadderPreview extends StatelessWidget {
  final LadderEntity ladder;
  final List<ProblemEntity> problems;
  final VoidCallback onSeeAll;

  const _LadderPreview({
    required this.ladder,
    required this.problems,
    required this.onSeeAll,
  });

  @override
  Widget build(BuildContext context) {
    final today = ladder.todaysRung;
    // Show at most 3 rungs: last solved + today + next
    final showRungs = ladder.rungs.take(4).toList();

    return GradientCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SectionHeader(
                ladder.title,
                icon: Icons.stairs_rounded,
                trailing: '${ladder.solvedCount}/${ladder.rungs.length}',
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          ProgressRing(
            ratio: ladder.ratio,
            size: 32,
            stroke: 4,
            color: UiConstants.primaryButtonColor,
            center: Text(
              '${(ladder.ratio * 100).round()}%',
              style: const TextStyle(
                  fontSize: 8,
                  color: UiConstants.primaryButtonColor,
                  fontWeight: FontWeight.w900),
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          for (final rung in showRungs)
            Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.xs),
              child: _buildRung(context, rung, rung == today),
            ),
          GestureDetector(
            onTap: onSeeAll,
            child: const Padding(
              padding: EdgeInsets.only(top: AppSpacing.xs),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text('Full ladder',
                      style: TextStyle(
                          color: UiConstants.primaryButtonColor,
                          fontSize: 13,
                          fontWeight: FontWeight.w700)),
                  SizedBox(width: 4),
                  Icon(Icons.arrow_forward_rounded,
                      size: 14, color: UiConstants.primaryButtonColor),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRung(BuildContext context, LadderRungEntity rung, bool isToday) {
    ProblemEntity? problem;
    try {
      problem = problems.firstWhere((p) => p.problemId == rung.problemId);
    } catch (_) {}

    return LadderRungTile(
      rating: rung.rating,
      problemTitle: problem?.title ?? rung.problemId,
      solved: rung.solved,
      isToday: isToday,
      topicLabel: rung.topicId,
      onTap: () {
        if (problem != null) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ProblemDetailsPage(problem: problem!),
            ),
          );
        }
      },
    );
  }
}
