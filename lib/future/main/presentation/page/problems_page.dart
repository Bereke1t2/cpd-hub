import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lab_portal/core/theme/app_colors.dart';
import 'package:lab_portal/core/theme/app_dimens.dart';
import 'package:lab_portal/core/ui_constants.dart';
import 'package:lab_portal/core/widgets/app_card.dart';
import 'package:lab_portal/core/widgets/app_chip.dart';
import 'package:lab_portal/core/widgets/app_text.dart';
import 'package:lab_portal/core/widgets/async_view.dart';
import 'package:lab_portal/future/main/presentation/page/base_page.dart';
import 'package:lab_portal/future/main/presentation/page/problem_details_page.dart';
import 'package:lab_portal/future/main/presentation/widget/search.dart';
import 'package:lab_portal/future/main/presentation/bloc/problems/problems_bloc.dart';
import 'package:lab_portal/core/di/injection.dart';
import 'package:lab_portal/future/main/domain/entity/problem_entity.dart';

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
      create: (_) => getIt<ProblemsBloc>()..add(ProblemsStarted()),
      child: BlocListener<ProblemsBloc, ProblemsState>(
        listener: (context, state) {
          if (state is ProblemsActionError) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.red.shade700,
              behavior: SnackBarBehavior.floating,
            ));
          }
        },
        child: BasePage(
          selectedIndex: 1,
          title: 'Problems',
          subtitle: 'Explore and solve coding challenges',
          body: LayoutBuilder(
            builder: (context, constraints) {
              final isWide = constraints.maxWidth >= 900;
              return SizedBox(
                height: constraints.maxHeight,
                child: Column(
                  children: [
                    const SizedBox(height: AppDimens.sm),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: AppDimens.sm),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 3,
                            child: SearchBox(
                              hintText: 'Search problems…',
                              onChanged: (v) => context
                                  .read<ProblemsBloc>()
                                  .add(ProblemsSearchChanged(v)),
                            ),
                          ),
                          const SizedBox(width: AppDimens.sm),
                          _difficultyFilter(),
                          const SizedBox(width: AppDimens.sm),
                          _sortMenu(),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppDimens.md),
                    Expanded(
                      child: BlocBuilder<ProblemsBloc, ProblemsState>(
                        builder: (context, state) =>
                            AsyncView<List<ProblemEntity>>(
                          isLoading: state is ProblemsLoading ||
                              state is ProblemsInitial,
                          error: state is ProblemsError
                              ? state.message
                              : null,
                          data: state is ProblemsLoaded
                              ? state.problems
                              : null,
                          onRetry: () => context
                              .read<ProblemsBloc>()
                              .add(ProblemsStarted()),
                          emptyMessage: 'No problems yet',
                          builder: (problems) {
                            final filtered = _applyFilters(problems);
                            if (filtered.isEmpty) {
                              return Center(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.search_off,
                                        size: 56,
                                        color: UiConstants.subtitleTextColor
                                            .withValues(alpha: 0.6)),
                                    const SizedBox(height: AppDimens.md),
                                    AppText.title('No problems found'),
                                    const SizedBox(height: AppDimens.xs),
                                    AppText.caption(
                                        'Try changing your search or filters.'),
                                  ],
                                ),
                              );
                            }
                            if (isWide) {
                              return GridView.builder(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: AppDimens.md,
                                    vertical: AppDimens.sm),
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  mainAxisSpacing: AppDimens.md,
                                  crossAxisSpacing: AppDimens.md,
                                  childAspectRatio: 3.2,
                                ),
                                itemCount: filtered.length,
                                itemBuilder: (context, index) =>
                                    RepaintBoundary(
                                  child: ProblemCard(
                                    problem: filtered[index],
                                    onTap: () => _openDetails(
                                        context, filtered[index]),
                                  ),
                                ),
                              );
                            }
                            return ListView.separated(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: AppDimens.md,
                                  vertical: AppDimens.sm),
                              itemCount: filtered.length,
                              separatorBuilder: (_, __) =>
                                  const SizedBox(height: AppDimens.sm),
                              itemBuilder: (context, index) =>
                                  RepaintBoundary(
                                child: ProblemCard(
                                  problem: filtered[index],
                                  onTap: () =>
                                      _openDetails(context, filtered[index]),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  List<ProblemEntity> _applyFilters(List<ProblemEntity> problems) {
    var list = List<ProblemEntity>.from(problems);
    if (_filterDifficulty != 'All') {
      list = list
          .where((p) =>
              p.difficulty.toLowerCase() == _filterDifficulty.toLowerCase())
          .toList();
    }
    if (_sortBy == 'Popular') {
      list.sort((a, b) => b.numberOfLikes.compareTo(a.numberOfLikes));
    }
    return list;
  }

  void _openDetails(BuildContext context, ProblemEntity p) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => ProblemDetailsPage(problem: p)),
    );
  }

  Widget _difficultyFilter() {
    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: AppDimens.sm, vertical: AppDimens.xs),
      decoration: BoxDecoration(
        color: UiConstants.infoBackgroundColor,
        borderRadius: AppDimens.brMd,
        border: Border.all(
            color: UiConstants.primaryButtonColor.withValues(alpha: 0.08)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _filterDifficulty,
          items: ['All', 'Easy', 'Medium', 'Hard']
              .map((o) => DropdownMenuItem(value: o, child: Text(o)))
              .toList(),
          onChanged: (v) => setState(() => _filterDifficulty = v ?? 'All'),
          iconEnabledColor: UiConstants.primaryButtonColor,
        ),
      ),
    );
  }

  Widget _sortMenu() {
    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: AppDimens.sm, vertical: AppDimens.xs),
      decoration: BoxDecoration(
        color: UiConstants.infoBackgroundColor,
        borderRadius: AppDimens.brMd,
        border: Border.all(
            color: UiConstants.primaryButtonColor.withValues(alpha: 0.08)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _sortBy,
          items: ['Newest', 'Popular']
              .map((o) => DropdownMenuItem(value: o, child: Text(o)))
              .toList(),
          onChanged: (v) => setState(() => _sortBy = v ?? 'Newest'),
          iconEnabledColor: UiConstants.primaryButtonColor,
        ),
      ),
    );
  }
}

class ProblemCard extends StatelessWidget {
  final ProblemEntity problem;
  final VoidCallback? onTap;

  const ProblemCard({super.key, required this.problem, this.onTap});

  @override
  Widget build(BuildContext context) {
    final diffColor = AppColors.difficulty(problem.difficulty);
    final diffBg = AppColors.difficultyBg(problem.difficulty);

    return AppCard(
      onTap: onTap,
      child: Row(
        children: [
          // Difficulty badge
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: diffBg,
              borderRadius: AppDimens.brSm,
              border: Border.all(color: diffColor.withValues(alpha: 0.30)),
            ),
            child: Center(
              child: Text(
                problem.difficulty[0].toUpperCase(),
                style: TextStyle(
                    color: diffColor,
                    fontSize: AppDimens.fH1,
                    fontWeight: FontWeight.w900),
              ),
            ),
          ),
          const SizedBox(width: AppDimens.md),
          // Main content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: AppText.title(problem.title,
                          maxLines: 2, overflow: TextOverflow.ellipsis),
                    ),
                    const SizedBox(width: AppDimens.sm),
                    Icon(Icons.star_border,
                        size: AppDimens.iconSm,
                        color: UiConstants.subtitleTextColor),
                  ],
                ),
                const SizedBox(height: AppDimens.sm),
                if (problem.tags.isNotEmpty)
                  Wrap(
                    spacing: AppDimens.xs,
                    runSpacing: AppDimens.xs,
                    children: problem.tags.take(4).map((t) {
                      return AppChip(t,
                          color: UiConstants.primaryButtonColor,
                          backgroundColor: UiConstants.primaryButtonColor
                              .withValues(alpha: 0.08));
                    }).toList(),
                  ),
                const SizedBox(height: AppDimens.sm),
                Row(
                  children: [
                    Icon(Icons.people_outline,
                        size: 13, color: UiConstants.subtitleTextColor),
                    const SizedBox(width: AppDimens.xs),
                    Flexible(
                      child: AppText.caption(
                          '${problem.numberOfSolvedPeople} solved'),
                    ),
                    const SizedBox(width: AppDimens.md),
                    Icon(Icons.thumb_up_outlined,
                        size: 13, color: UiConstants.subtitleTextColor),
                    const SizedBox(width: AppDimens.xs),
                    AppText.caption('${problem.numberOfLikes}'),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: AppDimens.sm),
          // Action
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              GestureDetector(
                onTap: onTap,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: AppDimens.md, vertical: AppDimens.sm),
                  decoration: BoxDecoration(
                    color: UiConstants.primaryButtonColor,
                    borderRadius: AppDimens.brSm,
                  ),
                  child:
                      const Icon(Icons.play_arrow, color: Colors.white, size: AppDimens.iconMd),
                ),
              ),
              const SizedBox(height: AppDimens.xs),
              AppChip(problem.difficulty, color: diffColor, backgroundColor: diffBg),
            ],
          ),
        ],
      ),
    );
  }
}
