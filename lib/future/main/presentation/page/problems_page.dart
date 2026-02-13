import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
            return _buildContent(state);
          }
          if (state is ProblemsError) {
            return Center(child: Text(state.message, style: const TextStyle(color: Colors.redAccent)));
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildContent(ProblemsLoaded state) {
    final filteredProblems = state.problems.where((p) {
      final matchesSearch = p.title.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesDifficulty = _selectedDifficulty == "All" || p.difficulty == _selectedDifficulty;
      return matchesSearch && matchesDifficulty;
    }).toList();

    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        _buildCreativeHeader(),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
            child: _buildFilters(),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
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
        const SliverToBoxAdapter(child: SizedBox(height: 100)),
      ],
    );
  }

  Widget _buildCreativeHeader() {
    return SliverToBoxAdapter(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              UiConstants.primaryButtonColor.withOpacity(0.12),
              Colors.transparent,
            ],
          ),
        ),
        child: Stack(
          children: [
            Positioned(
              right: -50,
              top: -50,
              child: Icon(
                Icons.code_rounded,
                size: 280,
                color: UiConstants.primaryButtonColor.withOpacity(0.03),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24.0, 48.0, 24.0, 32.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: UiConstants.primaryButtonColor.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(Icons.hub_rounded, color: UiConstants.primaryButtonColor, size: 24),
                      ),
                      const SizedBox(width: 16),
                      const Flexible(
                        child: Text(
                          "Challenge Hub",
                          style: TextStyle(
                            color: UiConstants.mainTextColor,
                            fontSize: 32,
                            fontWeight: FontWeight.w900,
                            letterSpacing: -1.2,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    "Master modern algorithms and data structures through our curated curriculum.",
                    style: TextStyle(
                      color: UiConstants.subtitleTextColor.withOpacity(0.6),
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 28),
                  _buildSearchField(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchField() {
    return Container(
      height: 56,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: TextField(
        controller: _searchController,
        onChanged: (val) => setState(() => _searchQuery = val),
        style: const TextStyle(color: Colors.white, fontSize: 14),
        decoration: InputDecoration(
          hintText: "Search challenges...",
          hintStyle: TextStyle(color: UiConstants.subtitleTextColor.withOpacity(0.4), fontSize: 13),
          prefixIcon: const Icon(Icons.search_rounded, color: UiConstants.primaryButtonColor, size: 20),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        ),
      ),
    );
  }

  Widget _buildFilters() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        children: ["All", "Easy", "Medium", "Hard"].map((diff) {
          final isSelected = _selectedDifficulty == diff;
          return Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: GestureDetector(
              onTap: () => setState(() => _selectedDifficulty = diff),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                decoration: BoxDecoration(
                  color: isSelected ? UiConstants.primaryButtonColor : Colors.white.withOpacity(0.03),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: isSelected ? Colors.transparent : Colors.white10),
                ),
                child: Row(
                  children: [
                    Icon(_getDifficultyIcon(diff), size: 14, color: isSelected ? Colors.black : UiConstants.subtitleTextColor),
                    const SizedBox(width: 8),
                    Text(diff, style: TextStyle(color: isSelected ? Colors.black : UiConstants.subtitleTextColor, fontWeight: FontWeight.w900, fontSize: 12, letterSpacing: 0.5)),
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