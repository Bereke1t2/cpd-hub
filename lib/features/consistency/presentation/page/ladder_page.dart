import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lab_portal/core/di/injection.dart';
import 'package:lab_portal/core/theme/app_spacing.dart';
import 'package:lab_portal/core/theme/app_text_styles.dart';
import 'package:lab_portal/core/ui_constants.dart';
import 'package:lab_portal/core/widgets/ui_kit.dart';
import 'package:lab_portal/future/main/domain/entity/problem_entity.dart';
import 'package:lab_portal/future/main/presentation/bloc/problems/problems_bloc.dart';
import 'package:lab_portal/future/main/presentation/page/problem_details_page.dart';
import '../../domain/entity/ladder_entity.dart';
import '../bloc/ladder/ladder_bloc.dart';
import '../cubit/goals/goals_cubit.dart';
import '../cubit/streak/streak_cubit.dart';
import '../widget/ladder_rung_tile.dart';

class LadderPage extends StatelessWidget {
  final LadderEntity ladder;

  const LadderPage({super.key, required this.ladder});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<ProblemsBloc>()..add(ProblemsStarted()),
      child: Scaffold(
        backgroundColor: UiConstants.backgroundColor,
        appBar: AppBar(
          backgroundColor: UiConstants.infoBackgroundColor,
          foregroundColor: UiConstants.mainTextColor,
          elevation: 0,
          title: Text(ladder.title, style: AppTextStyles.title),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: AppSpacing.sm),
              child: Center(
                child: Text(
                  '${ladder.solvedCount}/${ladder.rungs.length}',
                  style: AppTextStyles.stat.copyWith(
                      color: UiConstants.primaryButtonColor),
                ),
              ),
            ),
          ],
        ),
        body: Column(
          children: [
            // Progress bar header
            Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: GradientCard(
                child: Row(
                  children: [
                    ProgressRing(
                      ratio: ladder.ratio,
                      size: 52,
                      stroke: 6,
                      center: Text(
                        '${(ladder.ratio * 100).round()}%',
                        style: AppTextStyles.caption.copyWith(
                          color: UiConstants.primaryButtonColor,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${ladder.fromRating} → ${ladder.toRating}',
                            style: AppTextStyles.caption,
                          ),
                          Text(
                            '${ladder.solvedCount} of ${ladder.rungs.length} rungs climbed',
                            style: AppTextStyles.body,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Rung list
            Expanded(
              child: BlocBuilder<ProblemsBloc, ProblemsState>(
                builder: (context, state) {
                  final problems = state is ProblemsLoaded
                      ? state.problems
                      : <ProblemEntity>[];

                  return BlocBuilder<LadderBloc, LadderState>(
                    builder: (context, ladderState) {
                      // Use live ladder state if available (reflects solved rungs)
                      final live = ladderState is LadderLoaded
                          ? ladderState.ladders
                              .where((l) => l.id == ladder.id)
                              .firstOrNull
                          : null;
                      final display = live ?? ladder;
                      final todaysRung = display.todaysRung;

                      return ListView.separated(
                        padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.md, vertical: AppSpacing.xs),
                        itemCount: display.rungs.length,
                        separatorBuilder: (_, __) =>
                            const SizedBox(height: AppSpacing.xs),
                        itemBuilder: (context, i) {
                          final rung = display.rungs[i];
                          final isToday = rung == todaysRung;
                          ProblemEntity? problem;
                          try {
                            problem = problems
                                .firstWhere((p) => p.problemId == rung.problemId);
                          } catch (_) {}

                          return LadderRungTile(
                            rating: rung.rating,
                            problemTitle: problem?.title ?? rung.problemId,
                            solved: rung.solved,
                            isToday: isToday,
                            topicLabel: rung.topicId,
                            onTap: () => _onRungTap(context, rung, problem),
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onRungTap(
    BuildContext context,
    LadderRungEntity rung,
    ProblemEntity? problem,
  ) {
    if (problem == null) return;
    // Capture BLoC references before the async gap.
    final ladderBloc = context.read<LadderBloc>();
    final streakCubit = context.read<StreakCubit>();
    final goalsCubit = context.read<GoalsCubit>();

    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => ProblemDetailsPage(problem: problem)),
    ).then((_) {
      if (problem.isSolved && !rung.solved) {
        ladderBloc.add(LadderRungSolved(
          ladderId: ladder.id,
          problemId: rung.problemId,
        ));
        streakCubit.onProblemSolved();
        goalsCubit.onProblemSolved();
      }
    });
  }
}
