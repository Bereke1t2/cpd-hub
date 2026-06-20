import 'package:flutter/material.dart';
import 'package:lab_portal/core/widgets/async_view.dart';
import 'package:lab_portal/future/main/domain/entity/contest_entity.dart';
import 'package:lab_portal/future/main/presentation/page/base_page.dart';
import 'package:lab_portal/future/main/presentation/widget/contest_box.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lab_portal/future/main/presentation/bloc/contests/contests_bloc.dart';
import 'package:lab_portal/core/di/injection.dart';

import '../widget/bar_box.dart';
import 'package:lab_portal/future/main/presentation/page/contest_leaderboard_page.dart';

class ContestPage extends StatelessWidget {
  const ContestPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<ContestsBloc>()..add(ContestsStarted()),
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
                builder: (context, state) => AsyncView<List<ContestEntity>>(
                  isLoading: state is ContestsLoading || state is ContestsInitial,
                  error: state is ContestsError ? state.message : null,
                  data: state is ContestsLoaded ? state.contests : null,
                  isEmpty: (d) => d.isEmpty,
                  onRetry: () => context.read<ContestsBloc>().add(ContestsStarted()),
                  emptyMessage: 'No contests available',
                  builder: (contests) {
                    final upcoming = contests.where((c) => !c.isPast).toList();
                    final past = contests.where((c) => c.isPast).toList();

                    Widget sectionTitle(String text) => Padding(
                          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              text,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        );

                    Widget contestList(List<ContestEntity> items) =>
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: items.length,
                          itemBuilder: (context, index) {
                            final c = items[index];
                            return ContestBox(
                              title: c.title,
                              date: DateTime.tryParse(c.startTime) ?? DateTime.now(),
                              participated: c.isParticipating,
                              numberOfProblems: c.numberOfProblems,
                              time: DateTime.tryParse(c.startTime) ?? DateTime.now(),
                              numberOfContestants: 0, // will come from backend
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => ContestLeaderboardPage(contest: c),
                                ),
                              ),
                            );
                          },
                        );

                    return SingleChildScrollView(
                      child: Column(
                        children: [
                          if (upcoming.isNotEmpty) ...[
                            sectionTitle('Upcoming Contests'),
                            contestList(upcoming),
                          ],
                          if (past.isNotEmpty) ...[
                            sectionTitle('Past Contests'),
                            contestList(past),
                          ],
                          if (upcoming.isEmpty && past.isEmpty)
                            const Padding(
                              padding: EdgeInsets.all(32),
                              child: Text('No contests available',
                                  style: TextStyle(
                                      color: Color(0xFF9E9E9E))),
                            ),
                          const SizedBox(height: 12),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}