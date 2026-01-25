import 'package:flutter/material.dart';
import 'package:lab_portal/future/main/presentation/page/base_page.dart';
import 'package:lab_portal/future/main/presentation/widget/search.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lab_portal/future/main/presentation/bloc/problems/problems_bloc.dart';
import 'package:lab_portal/future/main/presentation/di/main_di.dart';

import '../widget/problem_container.dart';

class ProblemsPage extends StatelessWidget {
  const ProblemsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => MainDI.buildProblemsBloc()..add(ProblemsStarted()),
      child: BasePage(
        selectedIndex: 1,
        title: 'Problems',
        subtitle: 'Explore and solve coding challenges',
        body: LayoutBuilder(
          builder: (context, constraints) {
            final maxWidth = constraints.maxWidth;
            final isWide = maxWidth >= 1000;
            final contentWidth = isWide ? 980.0 : maxWidth;

            return Align(
              alignment: Alignment.topCenter,
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: contentWidth),
                child: Column(
                  children: [
                    SearchBox(
                      hintText: 'Search problems...',
                      onChanged: (value) => context
                          .read<ProblemsBloc>()
                          .add(ProblemsSearchChanged(value)),
                    ),
                    const SizedBox(height: 4),
                    Expanded(
                      child: BlocBuilder<ProblemsBloc, ProblemsState>(
                        builder: (context, state) {
                          if (state is ProblemsLoading ||
                              state is ProblemsInitial) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          if (state is ProblemsError) {
                            return Center(
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Text(state.message),
                              ),
                            );
                          }

                          final problems = (state as ProblemsLoaded).problems;
                          if (problems.isEmpty) {
                            return const Center(
                              child: Text('No problems found'),
                            );
                          }

                          return ListView.builder(
                            padding: const EdgeInsets.only(top: 4, bottom: 12),
                            itemCount: problems.length,
                            itemBuilder: (context, index) {
                              final p = problems[index];
                              return ProblemContainer(
                                title: p.title,
                                difficulty: p.difficulty,
                                timestamp: DateTime.now(),
                                isSolved: p.isSolved,
                                likedCount: p.numberOfLikes,
                                dislikedCount: p.numberOfDislikes,
                                tags: p.tags,
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
          },
        ),
      ),
    );
  }
}