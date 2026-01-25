import 'package:flutter/material.dart';
import 'package:lab_portal/future/main/presentation/widget/problem_box.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lab_portal/future/main/presentation/bloc/daily_problem/daily_problem_bloc.dart';
import 'package:lab_portal/future/main/presentation/bloc/problems/problems_bloc.dart';
import 'package:lab_portal/future/main/presentation/di/main_di.dart';

import '../../../../core/ui_constants.dart';
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
              MainDI.buildDailyProblemBloc()..add(DailyProblemStarted()),
        ),
        BlocProvider(
          create: (_) => MainDI.buildProblemsBloc()..add(ProblemsStarted()),
        ),
      ],
      child: BasePage(
        selectedIndex: 0,
        title: 'Home',
        subtitle: 'Ready to solve today?',
        body: SingleChildScrollView(
          child: Column(
            children: [
              const WelcomeBackBox(name: 'Bereket'),
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
                builder: (context, state) {
                  if (state is DailyProblemLoading ||
                      state is DailyProblemInitial) {
                    return const Padding(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (state is DailyProblemError) {
                    return Padding(
                      padding: const EdgeInsets.all(12),
                      child: Text(state.message),
                    );
                  }
                  final daily = (state as DailyProblemLoaded).daily;
                  return TodaysProblemBox(
                    problemTitle: daily.title,
                    solved: daily.numberOfSolvedPeople.toDouble(),
                    tags: daily.tags,
                    liked: daily.numberOfLikes.toDouble(),
                    disliked: daily.numberOfDislikes.toDouble(),
                    difficulty: daily.difficulty,
                    isLiked: daily.isLiked,
                    isDisliked: daily.isDisliked,
                  );
                },
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                child: const Icon(Icons.grid_view,
                                    color: UiConstants.statTextColor, size: 20),
                              ),
                              const SizedBox(width: 12.0),
                              Text(
                                "All Problems",
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: UiConstants.mainTextColor),
                              ),
                            ],
                          ),
                        ),
                        Icon(Icons.arrow_drop_down,
                            color: UiConstants.subtitleTextColor),
                      ],
                    ),
                    const SizedBox(height: 12.0),
                    BlocBuilder<ProblemsBloc, ProblemsState>(
                      builder: (context, state) {
                        if (state is ProblemsLoading ||
                            state is ProblemsInitial) {
                          return const Padding(
                            padding: EdgeInsets.all(16),
                            child: CircularProgressIndicator(),
                          );
                        }
                        if (state is ProblemsError) {
                          return Padding(
                            padding: const EdgeInsets.all(12),
                            child: Text(state.message),
                          );
                        }

                        final problems =
                            (state as ProblemsLoaded).problems.take(5).toList();

                        return Column(
                          children: List.generate(problems.length, (index) {
                            final p = problems[index];
                            return ProblemBox(
                              title: p.title,
                              difficulty: p.difficulty,
                            );
                          }),
                        );
                      },
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, '/problems');
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 12.0, horizontal: 16),
                        decoration: BoxDecoration(
                          color:
                              UiConstants.primaryButtonColor.withOpacity(0.10),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'See more',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: UiConstants.primaryButtonColor,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Icon(
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