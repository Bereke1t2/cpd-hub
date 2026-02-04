import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lab_portal/future/main/presentation/page/base_page.dart';
import 'package:lab_portal/future/main/presentation/page/problem_details_page.dart';
import 'package:lab_portal/future/main/presentation/widget/search.dart';
import 'package:lab_portal/future/main/presentation/bloc/problems/problems_bloc.dart';
import 'package:lab_portal/future/main/presentation/di/main_di.dart';
import 'package:lab_portal/future/main/domain/entitiy/problem_entitiy.dart';
import 'package:lab_portal/core/ui_constants.dart';

class ProblemsPage extends StatefulWidget {
  const ProblemsPage({super.key});

  @override
  State<ProblemsPage> createState() => _ProblemsPageState();
}

class _ProblemsPageState extends State<ProblemsPage> {
  String _filterDifficulty = 'All';
  String _sortBy = 'Newest';

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
            final isWide = maxWidth >= 900;
            final contentWidth = isWide ? 960.0 : maxWidth;

            return Align(
              alignment: Alignment.topCenter,
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: contentWidth),
                child: Column(
                  children: [
                    const SizedBox(height: 8),
                    // Search + filters bar
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 3,
                            child: SearchBox(
                              hintText: 'Search problems by title, tag or id...',
                              onChanged: (value) => context
                                  .read<ProblemsBloc>()
                                  .add(ProblemsSearchChanged(value)),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            flex: 2,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                _difficultyFilter(),
                                const SizedBox(width: 8),
                                _sortMenu(),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Problems list / grid
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

                          final filtered = _applyFilters(problems);

                          if (filtered.isEmpty) {
                            return Center(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.search_off, size: 64, color: UiConstants.subtitleTextColor.withOpacity(0.6)),
                                  const SizedBox(height: 12),
                                  const Text('No problems found', style: TextStyle(fontSize: 16)),
                                  const SizedBox(height: 6),
                                  const Text('Try changing your search or filters.', style: TextStyle(color: Color(0xFF9E9E9E))),
                                ],
                              ),
                            );
                          }

                          if (isWide) {
                            // beautiful masonry-like grid for wide screens
                            return GridView.builder(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                mainAxisSpacing: 12,
                                crossAxisSpacing: 12,
                                childAspectRatio: 3.2,
                              ),
                              itemCount: filtered.length,
                              itemBuilder: (context, index) {
                                final p = filtered[index];
                                return ProblemCard(
                                  problem: p,
                                  onTap: () => _openDetails(context, p),
                                );
                              },
                            );
                          }

                          // Narrow: single column list
                          return ListView.separated(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            itemCount: filtered.length,
                            separatorBuilder: (_, __) => const SizedBox(height: 8),
                            itemBuilder: (context, index) {
                              final p = filtered[index];
                              return ProblemCard(
                                problem: p,
                                onTap: () => _openDetails(context, p),
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

  List<ProblemEntity> _applyFilters(List<ProblemEntity> problems) {
    var list = List<ProblemEntity>.from(problems);
    if (_filterDifficulty != 'All') {
      list = list.where((p) => p.difficulty.toLowerCase() == _filterDifficulty.toLowerCase()).toList();
    }
    // simple sort
    if (_sortBy == 'Newest') {
      // assume problems come newest-first already
    } else if (_sortBy == 'Popular') {
      list.sort((a, b) => (b.numberOfLikes).compareTo(a.numberOfLikes));
    }
    return list;
  }

  void _openDetails(BuildContext context, ProblemEntity p) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ProblemDetailsPage(problem: p),
      ),
    );
  }

  Widget _difficultyFilter() {
    final options = ['All', 'Easy', 'Medium', 'Hard'];
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        color: UiConstants.infoBackgroundColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: UiConstants.primaryButtonColor.withOpacity(0.06)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _filterDifficulty,
          items: options.map((o) => DropdownMenuItem(value: o, child: Text(o))).toList(),
          onChanged: (v) => setState(() => _filterDifficulty = v ?? 'All'),
          iconEnabledColor: UiConstants.primaryButtonColor,
        ),
      ),
    );
  }

  Widget _sortMenu() {
    final options = ['Newest', 'Popular'];
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        color: UiConstants.infoBackgroundColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: UiConstants.primaryButtonColor.withOpacity(0.06)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _sortBy,
          items: options.map((o) => DropdownMenuItem(value: o, child: Text(o))).toList(),
          onChanged: (v) => setState(() => _sortBy = v ?? 'Newest'),
          iconEnabledColor: UiConstants.primaryButtonColor,
        ),
      ),
    );
  }
}

// Small, self-contained card used by the ProblemsPage to render each problem
class ProblemCard extends StatelessWidget {
  final ProblemEntity problem;
  final VoidCallback? onTap;

  const ProblemCard({super.key, required this.problem, this.onTap});

  Color _difficultyColor(String difficulty) {
    switch (difficulty.toLowerCase()) {
      case 'easy':
        return const Color(0xFF43A047);
      case 'medium':
        return const Color(0xFFFFA726);
      case 'hard':
        return const Color(0xFFE53935);
      default:
        return UiConstants.subtitleTextColor;
    }
  }

  @override
  Widget build(BuildContext context) {
    final diffColor = _difficultyColor(problem.difficulty);

    final card = Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: UiConstants.infoBackgroundColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: UiConstants.primaryButtonColor.withOpacity(0.04)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          // difficulty badge
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: diffColor.withOpacity(0.12),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: diffColor.withOpacity(0.18)),
            ),
            child: Center(
              child: Text(
                problem.difficulty[0].toUpperCase(),
                style: TextStyle(color: diffColor, fontSize: 20, fontWeight: FontWeight.w900),
              ),
            ),
          ),
          const SizedBox(width: 12),
          // main content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        problem.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: UiConstants.mainTextColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Icon(Icons.star_border, size: 18, color: UiConstants.subtitleTextColor),
                  ],
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: problem.tags.take(4).map((t) {
                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                      decoration: BoxDecoration(
                        color: UiConstants.primaryButtonColor.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(t, style: const TextStyle(color: UiConstants.primaryButtonColor, fontSize: 12, fontWeight: FontWeight.w600)),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Icon(Icons.people_outline, size: 14, color: UiConstants.subtitleTextColor),
                    const SizedBox(width: 6),
                    Text('${problem.numberOfSolvedPeople} solved', style: const TextStyle(color: UiConstants.subtitleTextColor, fontSize: 12)),
                    const SizedBox(width: 12),
                    Icon(Icons.thumb_up_outlined, size: 14, color: UiConstants.subtitleTextColor),
                    const SizedBox(width: 6),
                    Text('${problem.numberOfLikes}', style: const TextStyle(color: UiConstants.subtitleTextColor, fontSize: 12)),
                    const SizedBox(width: 12),
                    Icon(Icons.access_time, size: 14, color: UiConstants.subtitleTextColor),
                    const SizedBox(width: 6),
                    Text('~10m', style: const TextStyle(color: UiConstants.subtitleTextColor, fontSize: 12)),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          // action column
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              GestureDetector(
                onTap: onTap,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: UiConstants.primaryButtonColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.play_arrow, color: Colors.white),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                problem.difficulty,
                style: TextStyle(color: diffColor, fontWeight: FontWeight.w800),
              ),
            ],
          )
        ],
      ),
    );

    if (onTap == null) return card;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: card,
    );
  }
}
