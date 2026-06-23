import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lab_portal/core/di/injection.dart';
import 'package:lab_portal/core/theme/app_colors.dart';
import 'package:lab_portal/core/theme/app_dimens.dart';
import 'package:lab_portal/core/ui_constants.dart';
import 'package:lab_portal/core/widgets/app_card.dart';
import 'package:lab_portal/core/widgets/app_chip.dart';
import 'package:lab_portal/core/widgets/app_text.dart';
import 'package:lab_portal/future/main/domain/entity/problem_entity.dart';
import 'package:lab_portal/future/main/domain/usecase/like_it.dart';
import 'package:lab_portal/future/main/domain/usecase/dislike_it.dart';
import 'package:lab_portal/future/main/domain/usecase/make_it_solved.dart';
import 'package:lab_portal/future/main/domain/usecase/unmark_solved.dart';
import 'package:lab_portal/future/main/presentation/bloc/bookmarks/bookmarks_cubit.dart';
import 'package:lab_portal/future/main/presentation/page/base_page.dart';

class ProblemDetailsPage extends StatefulWidget {
  final ProblemEntity problem;
  const ProblemDetailsPage({super.key, required this.problem});

  @override
  State<ProblemDetailsPage> createState() => _ProblemDetailsPageState();
}

class _ProblemDetailsPageState extends State<ProblemDetailsPage> {
  late ProblemEntity _p;

  @override
  void initState() {
    super.initState();
    _p = widget.problem;
  }

  // ── helpers ────────────────────────────────────────────────────────────────

  void _snack(String msg) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: Colors.red.shade700,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Future<void> _toggleLike() async {
    final prev = _p;
    final wasLiked = _p.isLiked;
    setState(() {
      _p = _p.copyWith(
        isLiked: !wasLiked,
        numberOfLikes: wasLiked ? _p.numberOfLikes - 1 : _p.numberOfLikes + 1,
        isDisliked: wasLiked ? _p.isDisliked : false,
        numberOfDislikes: (!wasLiked && _p.isDisliked)
            ? _p.numberOfDislikes - 1
            : _p.numberOfDislikes,
      );
    });
    final result = wasLiked
        ? await getIt<DislikeIt>()(_p.problemId)
        : await getIt<LikeIt>()(_p.problemId);
    result.fold(
      (_) {},
      (f) { setState(() => _p = prev); _snack(f.message); },
    );
  }

  Future<void> _toggleDislike() async {
    final prev = _p;
    final wasDisliked = _p.isDisliked;
    setState(() {
      _p = _p.copyWith(
        isDisliked: !wasDisliked,
        numberOfDislikes:
            wasDisliked ? _p.numberOfDislikes - 1 : _p.numberOfDislikes + 1,
        isLiked: wasDisliked ? _p.isLiked : false,
        numberOfLikes: (!wasDisliked && _p.isLiked)
            ? _p.numberOfLikes - 1
            : _p.numberOfLikes,
      );
    });
    final result = wasDisliked
        ? await getIt<LikeIt>()(_p.problemId)
        : await getIt<DislikeIt>()(_p.problemId);
    result.fold(
      (_) {},
      (f) { setState(() => _p = prev); _snack(f.message); },
    );
  }

  Future<void> _toggleSolved() async {
    final prev = _p;
    final wasSolved = _p.isSolved;
    setState(() {
      _p = _p.copyWith(
        isSolved: !wasSolved,
        numberOfSolvedPeople: wasSolved
            ? _p.numberOfSolvedPeople - 1
            : _p.numberOfSolvedPeople + 1,
      );
    });
    final result = wasSolved
        ? await getIt<UnmarkSolved>()(_p.problemId)
        : await getIt<MakeItSolved>()(_p.problemId);
    result.fold(
      (_) {},
      (f) { setState(() => _p = prev); _snack(f.message); },
    );
  }

  void _copyUrl() {
    Clipboard.setData(ClipboardData(text: _p.problemUrl));
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Problem URL copied to clipboard'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  // ── build ──────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final diffColor = AppColors.difficulty(_p.difficulty);

    return BlocProvider.value(
      value: getIt<BookmarksCubit>(),
      child: BasePage(
        title: 'Problem',
        subtitle: _p.title,
        selectedIndex: 1,
        body: LayoutBuilder(builder: (context, constraints) {
          final contentMax =
              constraints.maxWidth > 1000 ? 900.0 : constraints.maxWidth;
          return Align(
            alignment: Alignment.topCenter,
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: contentMax),
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(AppDimens.md),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _headerCard(diffColor),
                    const SizedBox(height: AppDimens.md),
                    LayoutBuilder(builder: (context, c2) {
                      final isWide = c2.maxWidth > 700;
                      if (!isWide) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _descriptionSection(),
                            const SizedBox(height: AppDimens.md),
                            _metaSidebar(),
                          ],
                        );
                      }
                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(flex: 3, child: _descriptionSection()),
                          const SizedBox(width: AppDimens.md),
                          ConstrainedBox(
                            constraints: const BoxConstraints(maxWidth: 280),
                            child: _metaSidebar(),
                          ),
                        ],
                      );
                    }),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  // ── header ───────────────────────────────────────────────────────────────
  Widget _headerCard(Color diffColor) {
    return BlocBuilder<BookmarksCubit, Set<String>>(
      builder: (context, bookmarks) {
        final isBookmarked = bookmarks.contains(_p.problemId);
        return AppCard(
          accent: diffColor,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: AppText.h2(_p.title,
                        maxLines: 3, overflow: TextOverflow.ellipsis),
                  ),
                  const SizedBox(width: AppDimens.sm),
                  _IconToggle(
                    icon: isBookmarked
                        ? Icons.bookmark_rounded
                        : Icons.bookmark_border_rounded,
                    active: isBookmarked,
                    tooltip: isBookmarked ? 'Remove bookmark' : 'Bookmark',
                    onTap: () =>
                        context.read<BookmarksCubit>().toggle(_p.problemId),
                  ),
                ],
              ),
              const SizedBox(height: AppDimens.sm),
              // Wrap so the pill + stat reflow instead of overflowing.
              Wrap(
                spacing: AppDimens.sm,
                runSpacing: AppDimens.xs,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  AppChip(_p.difficulty,
                      color: diffColor,
                      backgroundColor: AppColors.difficultyBg(_p.difficulty)),
                  _MetaStat(
                    icon: Icons.people_outline,
                    label: '${_compact(_p.numberOfSolvedPeople)} solved',
                  ),
                  if (_p.isSolved)
                    const _MetaStat(
                      icon: Icons.check_circle_rounded,
                      label: 'Solved',
                      tint: UiConstants.primaryButtonColor,
                    ),
                ],
              ),
              if (_p.tags.isNotEmpty) ...[
                const SizedBox(height: AppDimens.md),
                Wrap(
                  spacing: AppDimens.xs,
                  runSpacing: AppDimens.xs,
                  children: _p.tags.map((t) => _TagChip(t)).toList(),
                ),
              ],
            ],
          ),
        );
      },
    );
  }

  // ── description ────────────────────────────────────────────────────────────
  Widget _descriptionSection() {
    return _SectionCard(
      icon: Icons.description_outlined,
      title: 'Problem Description',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SelectableText(
            _p.description.isNotEmpty
                ? _p.description
                : 'Given an array of integers, find two numbers such that they add up to a specific target number.\n\nYou may assume that each input would have exactly one solution, and you may not use the same element twice.\n\nReturn the indices of the two numbers.',
            style: TextStyle(
              color: UiConstants.subtitleTextColor,
              fontSize: AppDimens.fBody,
              height: 1.6,
            ),
          ),
          const SizedBox(height: AppDimens.md),
          _ExampleBlock(),
          const SizedBox(height: AppDimens.md),
          // Stacked full-width actions — never overflow regardless of text size.
          _PrimaryButton(
            icon: Icons.open_in_new_rounded,
            label: 'Open Problem',
            onTap: _copyUrl,
          ),
          const SizedBox(height: AppDimens.sm),
          _SecondaryButton(
            icon: _p.isSolved
                ? Icons.check_circle_rounded
                : Icons.check_circle_outline_rounded,
            label: _p.isSolved ? 'Mark Unsolved' : 'Mark Solved',
            active: _p.isSolved,
            onTap: _toggleSolved,
          ),
        ],
      ),
    );
  }

  // ── sidebar ────────────────────────────────────────────────────────────────
  Widget _metaSidebar() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionCard(
          icon: Icons.lightbulb_outline_rounded,
          title: 'Hints',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _hintItem(1, 'Try using a hash map for O(n) time'),
              _hintItem(2, 'Consider the complement for each number'),
              _hintItem(3, 'One pass is enough with a map'),
            ],
          ),
        ),
        const SizedBox(height: AppDimens.md),
        _SectionCard(
          icon: Icons.insights_rounded,
          title: 'Stats',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _statRow('Likes', _compact(_p.numberOfLikes)),
              const SizedBox(height: AppDimens.xs),
              _statRow('Dislikes', _compact(_p.numberOfDislikes)),
              const SizedBox(height: AppDimens.xs),
              _statRow('Solved by', _compact(_p.numberOfSolvedPeople)),
              const Divider(height: AppDimens.lg, color: UiConstants.borderColor),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _voteButton(
                    icon: _p.isLiked
                        ? Icons.thumb_up_rounded
                        : Icons.thumb_up_outlined,
                    count: _p.numberOfLikes,
                    active: _p.isLiked,
                    activeColor: UiConstants.primaryButtonColor,
                    onTap: _toggleLike,
                    tooltip: _p.isLiked ? 'Unlike' : 'Like',
                  ),
                  _voteButton(
                    icon: _p.isDisliked
                        ? Icons.thumb_down_rounded
                        : Icons.thumb_down_outlined,
                    count: _p.numberOfDislikes,
                    active: _p.isDisliked,
                    activeColor: const Color(0xFFF44336),
                    onTap: _toggleDislike,
                    tooltip: _p.isDisliked ? 'Remove dislike' : 'Dislike',
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _statRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(child: AppText.caption(label)),
        const SizedBox(width: AppDimens.sm),
        AppText.title(value, fontWeight: FontWeight.w800),
      ],
    );
  }

  Widget _voteButton({
    required IconData icon,
    required int count,
    required bool active,
    required Color activeColor,
    required VoidCallback onTap,
    required String tooltip,
  }) {
    final color = active ? activeColor : UiConstants.subtitleTextColor;
    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppDimens.brSm,
        child: Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: AppDimens.md, vertical: AppDimens.sm),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: color, size: AppDimens.iconMd),
              const SizedBox(height: AppDimens.xs),
              Text(_compact(count),
                  style: TextStyle(
                      color: color,
                      fontSize: AppDimens.fCaption,
                      fontWeight: FontWeight.w700)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _hintItem(int number, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppDimens.sm),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 24,
            height: 24,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: UiConstants.primaryButtonColor.withValues(alpha: 0.12),
              borderRadius: AppDimens.brSm,
            ),
            child: Text('$number',
                style: const TextStyle(
                    color: UiConstants.primaryButtonColor,
                    fontSize: AppDimens.fCaption,
                    fontWeight: FontWeight.w800)),
          ),
          const SizedBox(width: AppDimens.sm),
          Expanded(
            child: AppText.caption(text, maxLines: 3,
                overflow: TextOverflow.ellipsis),
          ),
        ],
      ),
    );
  }

  // 1234 → "1.2k".
  static String _compact(int n) {
    if (n >= 1000000) return '${(n / 1000000).toStringAsFixed(1)}M';
    if (n >= 1000) return '${(n / 1000).toStringAsFixed(1)}k';
    return '$n';
  }
}

// ── shared bits ───────────────────────────────────────────────────────────────

class _SectionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final Widget child;
  const _SectionCard(
      {required this.icon, required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(AppDimens.sm),
                decoration: BoxDecoration(
                  color: UiConstants.primaryButtonColor.withValues(alpha: 0.10),
                  borderRadius: AppDimens.brSm,
                ),
                child: Icon(icon,
                    color: UiConstants.primaryButtonColor,
                    size: AppDimens.iconMd),
              ),
              const SizedBox(width: AppDimens.sm),
              Expanded(
                child: AppText.title(title,
                    maxLines: 1, overflow: TextOverflow.ellipsis),
              ),
            ],
          ),
          const SizedBox(height: AppDimens.md),
          child,
        ],
      ),
    );
  }
}

class _ExampleBlock extends StatelessWidget {
  static const _text =
      'Input: nums = [2, 7, 11, 15], target = 9\nOutput: [0, 1]\nExplanation: nums[0] + nums[1] = 9';

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppDimens.md),
      decoration: BoxDecoration(
        color: UiConstants.backgroundColor.withValues(alpha: 0.5),
        borderRadius: AppDimens.brSm,
        border: Border.all(
            color: UiConstants.primaryButtonColor.withValues(alpha: 0.12)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText.caption('Example',
                    color: UiConstants.primaryButtonColor),
                const SizedBox(height: AppDimens.sm),
                const SelectableText(
                  _text,
                  style: TextStyle(
                    color: UiConstants.mainTextColor,
                    fontFamily: 'monospace',
                    fontSize: AppDimens.fBody,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () =>
                Clipboard.setData(const ClipboardData(text: _text)),
            icon: const Icon(Icons.copy_rounded,
                size: AppDimens.iconSm,
                color: UiConstants.subtitleTextColor),
            tooltip: 'Copy example',
          ),
        ],
      ),
    );
  }
}

class _PrimaryButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  const _PrimaryButton(
      {required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: AppDimens.md),
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
              color: UiConstants.primaryButtonColor.withValues(alpha: 0.30),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: AppDimens.iconSm),
            const SizedBox(width: AppDimens.sm),
            Flexible(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: AppDimens.fBody,
                    fontWeight: FontWeight.w800),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SecondaryButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool active;
  final VoidCallback onTap;
  const _SecondaryButton(
      {required this.icon,
      required this.label,
      required this.active,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    final color = UiConstants.primaryButtonColor;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: AppDimens.md),
        decoration: BoxDecoration(
          color: active ? color.withValues(alpha: 0.14) : Colors.transparent,
          borderRadius: AppDimens.brMd,
          border: Border.all(color: color.withValues(alpha: 0.45)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: AppDimens.iconSm),
            const SizedBox(width: AppDimens.sm),
            Flexible(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    color: color,
                    fontSize: AppDimens.fBody,
                    fontWeight: FontWeight.w800),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _IconToggle extends StatelessWidget {
  final IconData icon;
  final bool active;
  final String tooltip;
  final VoidCallback onTap;
  const _IconToggle(
      {required this.icon,
      required this.active,
      required this.tooltip,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: IconButton(
        onPressed: onTap,
        visualDensity: VisualDensity.compact,
        icon: Icon(
          icon,
          color: active
              ? UiConstants.primaryButtonColor
              : UiConstants.subtitleTextColor,
        ),
      ),
    );
  }
}

class _MetaStat extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color? tint;
  const _MetaStat({required this.icon, required this.label, this.tint});

  @override
  Widget build(BuildContext context) {
    final color = tint ?? UiConstants.subtitleTextColor;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: color),
        const SizedBox(width: AppDimens.xs),
        AppText.caption(label, color: color),
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
      padding:
          const EdgeInsets.symmetric(horizontal: AppDimens.sm, vertical: 3),
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
