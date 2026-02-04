import 'package:flutter/material.dart';
import 'package:lab_portal/core/ui_constants.dart';
import 'package:lab_portal/future/main/domain/entitiy/problem_entitiy.dart';
import 'package:lab_portal/future/main/presentation/page/base_page.dart';

class ProblemDetailsPage extends StatelessWidget {
  final ProblemEntity problem;

  const ProblemDetailsPage({super.key, required this.problem});

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

    return BasePage(
      title: 'Problem',
      subtitle: problem.title,
      selectedIndex: 1,
      body: LayoutBuilder(builder: (context, constraints) {
        final maxWidth = constraints.maxWidth;
        final contentMax = maxWidth > 1000 ? 900.0 : maxWidth;

        return Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: contentMax),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header card
                  Material(
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
                          color: UiConstants.primaryButtonColor.withOpacity(0.06),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Difficulty pill with icon
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: diffColor.withOpacity(0.12),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Icon(
                                  Icons.bar_chart, // represents difficulty
                                  color: diffColor,
                                  size: 22,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      problem.title,
                                      style: const TextStyle(
                                        color: UiConstants.mainTextColor,
                                        fontSize: 20,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    Row(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 12,
                                            vertical: 6,
                                          ),
                                          decoration: BoxDecoration(
                                            color: diffColor.withOpacity(0.14),
                                            borderRadius: BorderRadius.circular(20),
                                            border: Border.all(color: diffColor.withOpacity(0.28)),
                                          ),
                                          child: Text(
                                            problem.difficulty,
                                            style: TextStyle(
                                              color: diffColor,
                                              fontSize: 12,
                                              fontWeight: FontWeight.w800,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        Text(
                                          '${problem.numberOfSolvedPeople} solved',
                                          style: const TextStyle(
                                            color: UiConstants.subtitleTextColor,
                                            fontSize: 13,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 12),
                              // Quick actions (bookmark/solved badge)
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  IconButton(
                                    onPressed: () {},
                                    icon: Icon(
                                      problem.isSolved ? Icons.check_circle : Icons.bookmark_border,
                                      color: problem.isSolved ? Colors.green.shade400 : UiConstants.subtitleTextColor,
                                    ),
                                    tooltip: problem.isSolved ? 'Solved' : 'Bookmark',
                                  ),
                                  const SizedBox(height: 6),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 14),
                          // Tags row
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: problem.tags.map((tag) {
                              return Chip(
                                label: Text(tag, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                                backgroundColor: UiConstants.primaryButtonColor.withOpacity(0.08),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 18),

                  // Main content layout: description + sidebar on wide screens
                  LayoutBuilder(builder: (context, c2) {
                    final isWide = c2.maxWidth > 700;
                    return isWide
                        ? Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Left: description
                              Expanded(flex: 3, child: _descriptionSection(context)),
                              const SizedBox(width: 16),
                              // Right: meta / hints / stats
                              ConstrainedBox(
                                constraints: const BoxConstraints(maxWidth: 260),
                                child: _metaSidebar(context),
                              ),
                            ],
                          )
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _descriptionSection(context),
                              const SizedBox(height: 14),
                              _metaSidebar(context),
                            ],
                          );
                  }),
                ],
              ),
            ),
          ),
        );
      }),
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
            border: Border.all(color: UiConstants.primaryButtonColor.withOpacity(0.06)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: UiConstants.primaryButtonColor.withOpacity(0.10),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.description_outlined,
                      color: UiConstants.primaryButtonColor,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'Problem Description',
                    style: TextStyle(
                      color: UiConstants.mainTextColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              SelectableText(
                problem.description.isNotEmpty
                    ? problem.description
                    : 'Given an array of integers, find two numbers such that they add up to a specific target number.\n\nYou may assume that each input would have exactly one solution, and you may not use the same element twice.\n\nReturn the indices of the two numbers.\n\nExample:\n• Input: nums = [2, 7, 11, 15], target = 9\n• Output: [0, 1]\n• Explanation: nums[0] + nums[1] = 2 + 7 = 9',
                style: const TextStyle(
                  color: UiConstants.subtitleTextColor,
                  fontSize: 14,
                  height: 1.6,
                ),
              ),
              const SizedBox(height: 12),

              // Example I/O box
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.04),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Example',
                            style: TextStyle(fontWeight: FontWeight.w700),
                          ),
                          const SizedBox(height: 8),
                          SelectableText(
                            'Input: nums = [2, 7, 11, 15], target = 9\nOutput: [0, 1]\nExplanation: nums[0] + nums[1] = 9',
                            style: const TextStyle(fontFamily: 'monospace', fontSize: 13, height: 1.4),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        // copy example to clipboard
                      },
                      icon: const Icon(Icons.copy, size: 18),
                      tooltip: 'Copy example',
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 14),

              // Action buttons large
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.code),
                      label: const Padding(
                        padding: EdgeInsets.symmetric(vertical: 14),
                        child: Text('Solve Problem', style: TextStyle(fontWeight: FontWeight.w800)),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: UiConstants.primaryButtonColor,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        elevation: 0,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  OutlinedButton.icon(
                    onPressed: () {},
                    icon: Icon(problem.isSolved ? Icons.check_circle : Icons.bookmark_border, color: UiConstants.primaryButtonColor),
                    label: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      child: Text(problem.isSolved ? 'Solved' : 'Bookmark', style: const TextStyle(fontWeight: FontWeight.w800)),
                    ),
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      side: BorderSide(color: UiConstants.primaryButtonColor.withOpacity(0.18)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _metaSidebar(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: UiConstants.infoBackgroundColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: UiConstants.primaryButtonColor.withOpacity(0.06)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Hints', style: TextStyle(fontWeight: FontWeight.w700)),
              const SizedBox(height: 8),
              _hintItem(1, 'Try using a hash map for O(n) time'),
              _hintItem(2, 'Consider the complement for each number'),
              _hintItem(3, 'One pass is enough with a map'),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: UiConstants.infoBackgroundColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: UiConstants.primaryButtonColor.withOpacity(0.06)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Stats', style: TextStyle(fontWeight: FontWeight.w700)),
              const SizedBox(height: 8),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Text('Likes', style: TextStyle(color: UiConstants.subtitleTextColor)),
                Text('${problem.numberOfLikes}', style: const TextStyle(fontWeight: FontWeight.w800)),
              ]),
              const SizedBox(height: 6),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Text('Dislikes', style: TextStyle(color: UiConstants.subtitleTextColor)),
                Text('${problem.numberOfDislikes}', style: const TextStyle(fontWeight: FontWeight.w800)),
              ]),
            ],
          ),
        ),
      ],
    );
  }

  Widget _statItem(IconData icon, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: UiConstants.subtitleTextColor),
        const SizedBox(width: 6),
        Text(
          text,
          style: const TextStyle(
            color: UiConstants.subtitleTextColor,
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _hintItem(int number, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 26,
            height: 26,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: UiConstants.primaryButtonColor.withOpacity(0.12),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              '$number',
              style: const TextStyle(
                color: UiConstants.primaryButtonColor,
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                color: UiConstants.subtitleTextColor,
                fontSize: 13,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
