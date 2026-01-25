import 'package:flutter/material.dart';
import 'package:lab_portal/future/main/presentation/page/base_page.dart';
import 'package:lab_portal/future/main/presentation/widget/search.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lab_portal/future/main/presentation/bloc/problems/problems_bloc.dart';
import 'package:lab_portal/future/main/presentation/di/main_di.dart';

import '../widget/problem_container.dart';

class ProblemsPage extends StatelessWidget {
  ProblemsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => MainDI.buildProblemsBloc()..add(ProblemsStarted()),
      child: BasePage(
        selectedIndex: 1,
        title: 'Problems',
        subtitle: 'Explore and solve coding challenges',
        body: Column(
          children: [
            SearchBox(
              hintText: "Search problems...",
              onChanged: (value) =>
                  context.read<ProblemsBloc>().add(ProblemsSearchChanged(value)),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: BlocBuilder<ProblemsBloc, ProblemsState>(
                builder: (context, state) {
                  if (state is ProblemsLoading || state is ProblemsInitial) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (state is ProblemsError) {
                    return Center(child: Text(state.message));
                  }

                  final problems = (state as ProblemsLoaded).problems;
                  if (problems.isEmpty) {
                    return const Center(child: Text('No problems found'));
                  }

                  return ListView.builder(
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
  }
}