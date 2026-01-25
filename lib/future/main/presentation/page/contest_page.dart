import 'package:flutter/material.dart';
import 'package:lab_portal/future/main/presentation/page/base_page.dart';
import 'package:lab_portal/future/main/presentation/widget/contest_box.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lab_portal/future/main/presentation/bloc/contests/contests_bloc.dart';
import 'package:lab_portal/future/main/presentation/di/main_di.dart';

import '../widget/bar_box.dart';

class ContestPage extends StatelessWidget {
  const ContestPage({super.key});

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
                  return BarBox(
                    text: text,
                    isSelected: selected,
                    onTap: () => context
                        .read<ContestsBloc>()
                        .add(ContestsFilterChanged(text)),
                  );
                }

                return Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 6),
                  child: Wrap(
                    alignment: WrapAlignment.center,
                    spacing: 10,
                    runSpacing: 10,
                    children: [
                      chip('All'),
                      chip('Div1'),
                      chip('Div2'),
                    ],
                  ),
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

                  Widget sectionTitle(String text) {
                    return Padding(
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          text,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            color: Colors.white.withValues(alpha: 0.90),
                          ),
                        ),
                      ),
                    );
                  }

                  return SingleChildScrollView(
                    child: Column(
                      children: [
                        sectionTitle('Upcoming Contests'),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: upcoming.length,
                          itemBuilder: (context, index) {
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
                          },
                        ),
                        sectionTitle('Past Contests'),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: past.length,
                          itemBuilder: (context, index) {
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
                          },
                        ),
                        const SizedBox(height: 12),
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