import 'package:flutter/material.dart';
import 'package:lab_portal/future/main/presentation/page/base_page.dart';
import 'package:lab_portal/future/main/presentation/widget/contest_box.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lab_portal/future/main/presentation/bloc/contests/contests_bloc.dart';
import 'package:lab_portal/future/main/presentation/di/main_di.dart';

import '../widget/bar_box.dart';

class ContestPage extends StatelessWidget {
  ContestPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => MainDI.buildContestsBloc()..add(ContestsStarted()),
      child: BasePage(
        title: "Contests",
        selectedIndex: 2,
        subtitle: "Upcoming contests",
        body: Column(
          children: [
            BlocBuilder<ContestsBloc, ContestsState>(
              builder: (context, state) {
                final currentFilter =
                    state is ContestsLoaded ? state.filter : 'All';

                Widget chip(String text) {
                  final selected = currentFilter == text;
                  return GestureDetector(
                    onTap: () => context
                        .read<ContestsBloc>()
                        .add(ContestsFilterChanged(text)),
                    child: BarBox(text: text, isSelected: selected),
                  );
                }

                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    chip('All'),
                    const SizedBox(width: 16),
                    chip('Div1'),
                    const SizedBox(width: 16),
                    chip('Div2'),
                  ],
                );
              },
            ),
            Expanded(
              child: BlocBuilder<ContestsBloc, ContestsState>(
                builder: (context, state) {
                  if (state is ContestsLoading || state is ContestsInitial) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (state is ContestsError) {
                    return Center(child: Text(state.message));
                  }

                  final contests = (state as ContestsLoaded).contests;
                  final upcoming = contests.where((c) => !c.isPast).toList();
                  final past = contests.where((c) => c.isPast).toList();

                  return SingleChildScrollView(
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(16.0),
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Upcoming Contests',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white.withValues(alpha: 0.87),
                            ),
                          ),
                        ),
                        Column(
                          children: List.generate(upcoming.length, (index) {
                            final contest = upcoming[index];
                            return ContestBox(
                              title: contest.title,
                              date: DateTime.tryParse(contest.startTime) ??
                                  DateTime.now(),
                              participated: contest.isParticipating,
                              numberOfProblems: contest.numberOfProblems,
                              time: DateTime.tryParse(contest.startTime) ??
                                  DateTime.now(),
                              numberOfContestants: 1,
                            );
                          }),
                        ),
                        Container(
                          padding: const EdgeInsets.all(16.0),
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Past Contests',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white.withValues(alpha: 0.87),
                            ),
                          ),
                        ),
                        Column(
                          children: List.generate(past.length, (index) {
                            final contest = past[index];
                            return ContestBox(
                              title: contest.title,
                              date: DateTime.tryParse(contest.startTime) ??
                                  DateTime.now(),
                              participated: contest.isParticipating,
                              numberOfProblems: contest.numberOfProblems,
                              time: DateTime.tryParse(contest.startTime) ??
                                  DateTime.now(),
                              numberOfContestants: 1,
                            );
                          }),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}