import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cpd_hub/core/theme/theme_ext.dart';
import 'package:cpd_hub/core/ui_constants.dart';
import 'package:cpd_hub/future/main/presentation/bloc/problems_cubit.dart';
import 'package:cpd_hub/future/main/presentation/page/base_page.dart';
import '../widget/problem_container.dart';
import 'problem_details_page.dart';

class ProblemsPage extends StatefulWidget {
  const ProblemsPage({super.key});

  @override
  State<ProblemsPage> createState() => _ProblemsPageState();
}

class _ProblemsPageState extends State<ProblemsPage> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedDifficulty = "All";
  String _searchQuery = "";

  @override
  void initState() {
    super.initState();
    context.read<ProblemsCubit>().loadProblems();
  }

  @override
  Widget build(BuildContext context) {
    final sc = context.sc;
    return BasePage(
      selectedIndex: 1,
      title: 'Problems',
      subtitle: 'Master algorithms and data structures',
      body: BlocBuilder<ProblemsCubit, ProblemsState>(
        builder: (context, state) {
          if (state is ProblemsLoading) {
            return const Center(child: CircularProgressIndicator(color: UiConstants.primaryButtonColor));
          }
          if (state is ProblemsLoaded) {
            return _buildContent(context, state, sc);
          }
          if (state is ProblemsError) {
            return Center(child: Text(state.message, style: const TextStyle(color: Colors.redAccent)));
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildContent(BuildContext context, ProblemsLoaded state, double sc) {
    final filteredProblems = state.problems.where((p) {
      final matchesSearch = p.title.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesDifficulty = _selectedDifficulty == "All" || p.difficulty == _selectedDifficulty;
      return matchesSearch && matchesDifficulty;
    }).toList();

    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.fromLTRB(16 * sc, 16 * sc, 16 * sc, 8 * sc),
            child: _buildSearchField(sc),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.fromLTRB(16 * sc, 0, 16 * sc, 12 * sc),
            child: _buildFilters(sc),
          ),
        ),
        SliverPadding(
          padding: EdgeInsets.symmetric(horizontal: 16 * sc),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final p = filteredProblems[index];
                return ProblemContainer(
                  title: p.title,
                  difficulty: p.difficulty,
                  timestamp: DateTime.now().subtract(Duration(days: index + 1)),
                  isSolved: p.isSolved,
                  likedCount: p.numberOfLikes,
                  dislikedCount: p.numberOfDislikes,
                  tags: p.tags,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProblemDetailsPage(problemData: {
                        'title': p.title,
                        'difficulty': p.difficulty,
                        'likedCount': '${p.numberOfLikes}',
                        'dislikedCount': '${p.numberOfDislikes}',
                      }),
                    ),
                  ),
                );
              },
              childCount: filteredProblems.length,
            ),
          ),
        ),
        SliverToBoxAdapter(child: SizedBox(height: 80 * sc)),
      ],
    );
  }

  Widget _buildSearchField(double sc) {
    return Container(
      height: 44 * sc,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: TextField(
        controller: _searchController,
        onChanged: (val) => setState(() => _searchQuery = val),
        style: TextStyle(color: Colors.white, fontSize: 14 * sc),
        decoration: InputDecoration(
          hintText: "Search problems...",
          hintStyle: TextStyle(color: UiConstants.subtitleTextColor.withValues(alpha: 0.4), fontSize: 13 * sc),
          prefixIcon: Icon(Icons.search_rounded, color: UiConstants.primaryButtonColor, size: 20 * sc),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 16 * sc, vertical: 13 * sc),
        ),
      ),
    );
  }

  Widget _buildFilters(double sc) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        children: ["All", "Easy", "Medium", "Hard"].map((diff) {
          final isSelected = _selectedDifficulty == diff;
          return Padding(
            padding: EdgeInsets.only(right: 10.0 * sc),
            child: GestureDetector(
              onTap: () => setState(() => _selectedDifficulty = diff),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                padding: EdgeInsets.symmetric(horizontal: 14 * sc, vertical: 8 * sc),
                decoration: BoxDecoration(
                  color: isSelected ? UiConstants.primaryButtonColor : Colors.white.withValues(alpha: 0.03),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: isSelected ? Colors.transparent : Colors.white10),
                ),
                child: Row(
                  children: [
                    Icon(_getDifficultyIcon(diff), size: 14 * sc, color: isSelected ? Colors.black : UiConstants.subtitleTextColor),
                    SizedBox(width: 6 * sc),
                    Text(diff, style: TextStyle(color: isSelected ? Colors.black : UiConstants.subtitleTextColor, fontWeight: FontWeight.w900, fontSize: 12 * sc, letterSpacing: 0.5)),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  IconData _getDifficultyIcon(String difficulty) {
    switch (difficulty) {
      case "Easy": return Icons.bolt_rounded;
      case "Medium": return Icons.layers_rounded;
      case "Hard": return Icons.whatshot_rounded;
      default: return Icons.category_rounded;
    }
  }
}
