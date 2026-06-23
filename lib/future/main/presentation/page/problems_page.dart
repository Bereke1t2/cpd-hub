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
  static const _difficulties = ['All', 'Easy', 'Medium', 'Hard'];
  static const _sorts = ['Newest', 'Popular'];

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
                    SearchBox(
                      hintText: 'Search problems…',
                      onChanged: (v) => context
                          .read<ProblemsBloc>()
                          .add(ProblemsSearchChanged(v)),
                    ),
                    _FilterBar(
                      difficulties: _difficulties,
                      selected: _filterDifficulty,
                      sort: _sortBy,
                      onDifficulty: (d) =>
                          setState(() => _filterDifficulty = d),
                      onToggleSort: () => setState(() {
                        final i = _sorts.indexOf(_sortBy);
                        _sortBy = _sorts[(i + 1) % _sorts.length];
                      }),
                    ),
                    const SizedBox(height: AppDimens.sm),
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
                            if (filtered.isEmpty) return const _EmptyResults();
                            if (isWide) {
                              return GridView.builder(
                                padding: const EdgeInsets.fromLTRB(
                                    AppDimens.md,
                                    AppDimens.xs,
                                    AppDimens.md,
                                    AppDimens.md),
                                gridDelegate:
                                    const SliverGridDelegateWithMaxCrossAxisExtent(
                                  maxCrossAxisExtent: 520,
                                  mainAxisExtent: 156,
                                  mainAxisSpacing: AppDimens.md,
                                  crossAxisSpacing: AppDimens.md,
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
                              padding: const EdgeInsets.fromLTRB(AppDimens.md,
                                  AppDimens.xs, AppDimens.md, AppDimens.md),
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
}

// ── Filter bar: scrollable difficulty chips + a compact sort toggle ──────────
class _FilterBar extends StatelessWidget {
  final List<String> difficulties;
  final String selected;
  final String sort;
  final ValueChanged<String> onDifficulty;
  final VoidCallback onToggleSort;

  const _FilterBar({
    required this.difficulties,
    required this.selected,
    required this.sort,
    required this.onDifficulty,
    required this.onToggleSort,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppDimens.lg),
      child: Row(
        children: [
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  for (final d in difficulties)
                    Padding(
                      padding: const EdgeInsets.only(right: AppDimens.sm),
                      child: _DifficultyChip(
                        label: d,
                        selected: selected == d,
                        onTap: () => onDifficulty(d),
                      ),
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(width: AppDimens.sm),
          _SortToggle(label: sort, onTap: onToggleSort),
        ],
      ),
    );
  }
}

class _DifficultyChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _DifficultyChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // "All" stays neutral-green; named difficulties carry a small semantic dot.
    final hasDot = label != 'All';
    final dotColor = AppColors.difficulty(label);
    final fg = selected
        ? UiConstants.primaryButtonColor
        : UiConstants.subtitleTextColor;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(
            horizontal: AppDimens.md, vertical: AppDimens.xs),
        decoration: BoxDecoration(
          color: selected
              ? UiConstants.primaryButtonColor.withValues(alpha: 0.16)
              : UiConstants.infoBackgroundColor,
          borderRadius: const BorderRadius.all(Radius.circular(AppDimens.rPill)),
          border: Border.all(color: fg.withValues(alpha: 0.35)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (hasDot) ...[
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(color: dotColor, shape: BoxShape.circle),
              ),
              const SizedBox(width: AppDimens.xs),
            ],
            Text(
              label,
              style: TextStyle(
                color: fg,
                fontSize: AppDimens.fCaption,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SortToggle extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _SortToggle({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
            horizontal: AppDimens.md, vertical: AppDimens.xs),
        decoration: BoxDecoration(
          color: UiConstants.infoBackgroundColor,
          borderRadius: const BorderRadius.all(Radius.circular(AppDimens.rPill)),
          border: Border.all(
              color: UiConstants.primaryButtonColor.withValues(alpha: 0.30)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.swap_vert_rounded,
                size: AppDimens.iconSm, color: UiConstants.primaryButtonColor),
            const SizedBox(width: AppDimens.xs),
            Text(
              label,
              style: const TextStyle(
                color: UiConstants.primaryButtonColor,
                fontSize: AppDimens.fCaption,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyResults extends StatelessWidget {
  const _EmptyResults();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.search_off,
              size: 56,
              color: UiConstants.subtitleTextColor.withValues(alpha: 0.6)),
          const SizedBox(height: AppDimens.md),
          AppText.title('No problems found'),
          const SizedBox(height: AppDimens.xs),
          AppText.caption('Try changing your search or filters.'),
        ],
      ),
    );
  }
}

// ── Problem card ─────────────────────────────────────────────────────────────
// One difficulty signal (a labelled pill + a tinted accent border), a title,
// a wrap-based meta row that can never overflow, a few tags, and a single
// green action. Palette stays green / white / muted; the only other colours are
// the semantic difficulty pill (green / amber / red).
class ProblemCard extends StatelessWidget {
  final ProblemEntity problem;
  final VoidCallback? onTap;

  const ProblemCard({super.key, required this.problem, this.onTap});

  @override
  Widget build(BuildContext context) {
    final diffColor = AppColors.difficulty(problem.difficulty);
    final diffBg = AppColors.difficultyBg(problem.difficulty);
    final solved = problem.isSolved;

    return AppCard(
      onTap: onTap,
      accent: diffColor,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title + solved state.
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: AppText.title(problem.title,
                          maxLines: 2, overflow: TextOverflow.ellipsis),
                    ),
                    const SizedBox(width: AppDimens.sm),
                    Icon(
                      solved
                          ? Icons.check_circle_rounded
                          : Icons.bookmark_border_rounded,
                      size: AppDimens.iconSm,
                      color: solved
                          ? UiConstants.primaryButtonColor
                          : UiConstants.subtitleTextColor,
                    ),
                  ],
                ),
                const SizedBox(height: AppDimens.sm),
                // Meta — a Wrap so it reflows instead of overflowing.
                Wrap(
                  spacing: AppDimens.sm,
                  runSpacing: AppDimens.xs,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    AppChip(problem.difficulty,
                        color: diffColor, backgroundColor: diffBg),
                    _MetaStat(
                      icon: Icons.people_outline,
                      label: '${_compact(problem.numberOfSolvedPeople)} solved',
                    ),
                    _MetaStat(
                      icon: Icons.favorite_outline,
                      label: _compact(problem.numberOfLikes),
                    ),
                  ],
                ),
                if (problem.tags.isNotEmpty) ...[
                  const SizedBox(height: AppDimens.sm),
                  Wrap(
                    spacing: AppDimens.xs,
                    runSpacing: AppDimens.xs,
                    children: problem.tags
                        .take(3)
                        .map((t) => _TagChip(t))
                        .toList(),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(width: AppDimens.md),
          _SolveButton(onTap: onTap),
        ],
      ),
    );
  }

  // 1234 → "1.2k", 980 → "980".
  static String _compact(int n) {
    if (n >= 1000000) return '${(n / 1000000).toStringAsFixed(1)}M';
    if (n >= 1000) return '${(n / 1000).toStringAsFixed(1)}k';
    return '$n';
  }
}

class _MetaStat extends StatelessWidget {
  final IconData icon;
  final String label;
  const _MetaStat({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: UiConstants.subtitleTextColor),
        const SizedBox(width: AppDimens.xs),
        AppText.caption(label),
      ],
    );
  }
}

class _TagChip extends StatelessWidget {
  final String tag;
  const _TagChip(this.tag);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: AppDimens.sm, vertical: 3),
      decoration: BoxDecoration(
        color: UiConstants.primaryButtonColor.withValues(alpha: 0.08),
        borderRadius: const BorderRadius.all(Radius.circular(AppDimens.rPill)),
        border: Border.all(
            color: UiConstants.primaryButtonColor.withValues(alpha: 0.18)),
      ),
      child: Text(
        '#$tag',
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(
          color: UiConstants.subtitleTextColor,
          fontSize: AppDimens.fMicro,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _SolveButton extends StatelessWidget {
  final VoidCallback? onTap;
  const _SolveButton({this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [
              UiConstants.primaryButtonColor,
              UiConstants.primaryDark,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: AppDimens.brMd,
          boxShadow: [
            BoxShadow(
              color: UiConstants.primaryButtonColor.withValues(alpha: 0.35),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: const Icon(Icons.arrow_forward_rounded,
            color: Colors.white, size: AppDimens.iconMd),
      ),
    );
  }
}
