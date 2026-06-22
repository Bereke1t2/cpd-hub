import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lab_portal/core/di/injection.dart';
import 'package:lab_portal/core/theme/app_colors.dart';
import 'package:lab_portal/core/ui_constants.dart';
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

  // ---- helpers ----

  Color _difficultyColor(String difficulty) => AppColors.difficulty(difficulty);

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

  // ---- build ----

  @override
  Widget build(BuildContext context) {
    final diffColor = _difficultyColor(_p.difficulty);

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
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _headerCard(diffColor),
                    const SizedBox(height: 18),
                    LayoutBuilder(builder: (context, c2) {
                      final isWide = c2.maxWidth > 700;
                      return isWide
                          ? Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                    flex: 3,
                                    child: _descriptionSection(context)),
                                const SizedBox(width: 16),
                                ConstrainedBox(
                                  constraints:
                                      const BoxConstraints(maxWidth: 260),
                                  child: _metaSidebar(),
                                ),
                              ],
                            )
                          : Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _descriptionSection(context),
                                const SizedBox(height: 14),
                                _metaSidebar(),
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

  Widget _headerCard(Color diffColor) {
    return BlocBuilder<BookmarksCubit, Set<String>>(
      builder: (context, bookmarks) {
        final isBookmarked = bookmarks.contains(_p.problemId);
        return Material(
          color: UiConstants.infoBackgroundColor,
          borderRadius: BorderRadius.circular(16),
          elevation: 4,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: UiConstants.infoBackgroundColor,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                  color: UiConstants.primaryButtonColor.withValues(alpha: 0.06)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: diffColor.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(Icons.bar_chart, color: diffColor, size: 22),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(_p.title,
                              style: const TextStyle(
                                  color: UiConstants.mainTextColor,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w800)),
                          const SizedBox(height: 6),
                          Row(children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: diffColor.withValues(alpha: 0.14),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                    color: diffColor.withValues(alpha: 0.28)),
                              ),
                              child: Text(_p.difficulty,
                                  style: TextStyle(
                                      color: diffColor,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w800)),
                            ),
                            const SizedBox(width: 10),
                            Text('${_p.numberOfSolvedPeople} solved',
                                style: const TextStyle(
                                    color: UiConstants.subtitleTextColor,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600)),
                          ]),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    // Bookmark icon (top-right quick action)
                    Tooltip(
                      message: isBookmarked ? 'Remove bookmark' : 'Bookmark',
                      child: IconButton(
                        onPressed: () =>
                            context.read<BookmarksCubit>().toggle(_p.problemId),
                        icon: Icon(
                          isBookmarked
                              ? Icons.bookmark
                              : Icons.bookmark_border,
                          color: isBookmarked
                              ? UiConstants.primaryButtonColor
                              : UiConstants.subtitleTextColor,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _p.tags.map((tag) {
                    return Chip(
                      label: Text(tag,
                          style: const TextStyle(
                              fontSize: 12, fontWeight: FontWeight.w600)),
                      backgroundColor:
                          UiConstants.primaryButtonColor.withValues(alpha: 0.08),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _descriptionSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: UiConstants.infoBackgroundColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
                color: UiConstants.primaryButtonColor.withValues(alpha: 0.06)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: UiConstants.primaryButtonColor.withValues(alpha: 0.10),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.description_outlined,
                      color: UiConstants.primaryButtonColor, size: 20),
                ),
                const SizedBox(width: 12),
                const Text('Problem Description',
                    style: TextStyle(
                        color: UiConstants.mainTextColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w700)),
              ]),
              const SizedBox(height: 12),
              SelectableText(
                _p.description.isNotEmpty
                    ? _p.description
                    : 'Given an array of integers, find two numbers such that they add up to a specific target number.\n\nYou may assume that each input would have exactly one solution, and you may not use the same element twice.\n\nReturn the indices of the two numbers.\n\nExample:\n• Input: nums = [2, 7, 11, 15], target = 9\n• Output: [0, 1]\n• Explanation: nums[0] + nums[1] = 2 + 7 = 9',
                style: const TextStyle(
                    color: UiConstants.subtitleTextColor,
                    fontSize: 14,
                    height: 1.6),
              ),
              const SizedBox(height: 12),
              // Example I/O
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.04),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text('Example',
                              style: TextStyle(fontWeight: FontWeight.w700)),
                          SizedBox(height: 8),
                          SelectableText(
                            'Input: nums = [2, 7, 11, 15], target = 9\nOutput: [0, 1]\nExplanation: nums[0] + nums[1] = 9',
                            style: TextStyle(
                                fontFamily: 'monospace',
                                fontSize: 13,
                                height: 1.4),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () => Clipboard.setData(
                        const ClipboardData(
                          text:
                              'Input: nums = [2, 7, 11, 15], target = 9\nOutput: [0, 1]',
                        ),
                      ),
                      icon: const Icon(Icons.copy, size: 18),
                      tooltip: 'Copy example',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              // Action buttons
              Row(children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _copyUrl,
                    icon: const Icon(Icons.open_in_new),
                    label: const Padding(
                      padding: EdgeInsets.symmetric(vertical: 14),
                      child: Text('Open Problem',
                          style: TextStyle(fontWeight: FontWeight.w800)),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: UiConstants.primaryButtonColor,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      elevation: 0,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                OutlinedButton.icon(
                  onPressed: _toggleSolved,
                  icon: Icon(
                    _p.isSolved ? Icons.check_circle : Icons.check_circle_outline,
                    color: _p.isSolved
                        ? Colors.green.shade400
                        : UiConstants.primaryButtonColor,
                  ),
                  label: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    child: Text(
                      _p.isSolved ? 'Mark Unsolved' : 'Mark Solved',
                      style: const TextStyle(fontWeight: FontWeight.w800),
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: _p.isSolved
                        ? Colors.green.shade400
                        : UiConstants.primaryButtonColor,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    side: BorderSide(
                        color: UiConstants.primaryButtonColor.withValues(alpha: 0.18)),
                  ),
                ),
              ]),
            ],
          ),
        ),
      ],
    );
  }

  Widget _metaSidebar() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Hints
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: UiConstants.infoBackgroundColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
                color: UiConstants.primaryButtonColor.withValues(alpha: 0.06)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Hints',
                  style: TextStyle(fontWeight: FontWeight.w700)),
              const SizedBox(height: 8),
              _hintItem(1, 'Try using a hash map for O(n) time'),
              _hintItem(2, 'Consider the complement for each number'),
              _hintItem(3, 'One pass is enough with a map'),
            ],
          ),
        ),
        const SizedBox(height: 12),
        // Stats + like/dislike
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: UiConstants.infoBackgroundColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
                color: UiConstants.primaryButtonColor.withValues(alpha: 0.06)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Stats',
                  style: TextStyle(fontWeight: FontWeight.w700)),
              const SizedBox(height: 10),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                const Text('Likes',
                    style: TextStyle(color: UiConstants.subtitleTextColor)),
                Text('${_p.numberOfLikes}',
                    style: const TextStyle(fontWeight: FontWeight.w800)),
              ]),
              const SizedBox(height: 6),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                const Text('Dislikes',
                    style: TextStyle(color: UiConstants.subtitleTextColor)),
                Text('${_p.numberOfDislikes}',
                    style: const TextStyle(fontWeight: FontWeight.w800)),
              ]),
              const SizedBox(height: 6),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                const Text('Solved by',
                    style: TextStyle(color: UiConstants.subtitleTextColor)),
                Text('${_p.numberOfSolvedPeople}',
                    style: const TextStyle(fontWeight: FontWeight.w800)),
              ]),
              const Divider(height: 20),
              // Interactive like / dislike buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _voteButton(
                    icon: _p.isLiked
                        ? Icons.thumb_up
                        : Icons.thumb_up_outlined,
                    count: _p.numberOfLikes,
                    active: _p.isLiked,
                    activeColor: UiConstants.primaryButtonColor,
                    onTap: _toggleLike,
                    tooltip: _p.isLiked ? 'Unlike' : 'Like',
                  ),
                  _voteButton(
                    icon: _p.isDisliked
                        ? Icons.thumb_down
                        : Icons.thumb_down_outlined,
                    count: _p.numberOfDislikes,
                    active: _p.isDisliked,
                    activeColor: Colors.red.shade400,
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

  Widget _voteButton({
    required IconData icon,
    required int count,
    required bool active,
    required Color activeColor,
    required VoidCallback onTap,
    required String tooltip,
  }) {
    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Column(
            children: [
              Icon(icon,
                  color: active ? activeColor : UiConstants.subtitleTextColor,
                  size: 22),
              const SizedBox(height: 4),
              Text('$count',
                  style: TextStyle(
                      color:
                          active ? activeColor : UiConstants.subtitleTextColor,
                      fontSize: 12,
                      fontWeight: FontWeight.w700)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _hintItem(int number, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 26,
            height: 26,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: UiConstants.primaryButtonColor.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text('$number',
                style: const TextStyle(
                    color: UiConstants.primaryButtonColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w700)),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(text,
                style: const TextStyle(
                    color: UiConstants.subtitleTextColor,
                    fontSize: 13,
                    height: 1.4)),
          ),
        ],
      ),
    );
  }
}
