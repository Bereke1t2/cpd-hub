import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/ui_constants.dart';

class StreakProgressBox extends StatelessWidget {
  final int currentStreak;
  final int problemsSolved;
  final int totalProblems;

  const StreakProgressBox({
    super.key,
    this.currentStreak = 7,
    this.problemsSolved = 42,
    this.totalProblems = 100,
  });

  @override
  Widget build(BuildContext context) {
    final progress = (problemsSolved / totalProblems).clamp(0.0, 1.0);
    final activeColor = const Color(0xFF43A047);
    final flameColor = const Color(0xFFE53935);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            UiConstants.primaryButtonColor.withAlpha(31),
            UiConstants.infoBackgroundColor,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: UiConstants.primaryButtonColor.withAlpha((0.12 * 255).round()),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha((0.06 * 255).round()),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header row
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: flameColor.withAlpha((0.12 * 255).round()),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.local_fire_department,
                  color: flameColor,
                  size: 22,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Your Progress',
                      style: TextStyle(
                        color: UiConstants.mainTextColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Keep up the great work — consistency matters!',
                      style: TextStyle(
                        color: UiConstants.subtitleTextColor,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              // Streak badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: flameColor.withAlpha((0.10 * 255).round()),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: flameColor.withAlpha((0.2 * 255).round()),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.whatshot,
                      color: flameColor,
                      size: 16,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '$currentStreak days',
                      style: TextStyle(
                        color: flameColor,
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Weekly streak visualization — responsive: switch to Wrap on very narrow widths
          LayoutBuilder(builder: (context, constraints) {
            final dayNames = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
            final activeCount = (currentStreak % 7 == 0 ? 7 : currentStreak % 7);
            final itemSize = (constraints.maxWidth - 32) / 9; // rough spacing
            final boxSize = itemSize.clamp(28.0, 44.0);

            final children = List.generate(7, (index) {
              final isActive = index < activeCount;
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    width: boxSize,
                    height: boxSize,
                    decoration: BoxDecoration(
                      color: isActive ? activeColor : UiConstants.primaryButtonColor.withAlpha((0.08 * 255).round()),
                      borderRadius: BorderRadius.circular(10),
                      border: isActive
                          ? Border.all(color: activeColor.withAlpha((0.5 * 255).round()))
                          : Border.all(color: Colors.transparent),
                    ),
                    child: isActive
                        ? const Icon(Icons.check, color: Colors.white, size: 18)
                        : null,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    dayNames[index],
                    style: TextStyle(
                      color: isActive ? UiConstants.mainTextColor : UiConstants.subtitleTextColor,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              );
            });

            if (constraints.maxWidth < 360) {
              // very narrow — wrap to multiple rows
              return Wrap(
                alignment: WrapAlignment.spaceAround,
                spacing: 8,
                runSpacing: 8,
                children: children.map((c) => SizedBox(width: boxSize + 8, child: c)).toList(),
              );
            }

            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: children,
            );
          }),

          const SizedBox(height: 16),

          // Progress bar
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Problems Solved',
                    style: TextStyle(
                      color: UiConstants.subtitleTextColor,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    '$problemsSolved / $totalProblems',
                    style: const TextStyle(
                      color: UiConstants.mainTextColor,
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: LinearProgressIndicator(
                  value: progress,
                  minHeight: 10,
                  backgroundColor: UiConstants.primaryButtonColor.withAlpha((0.12 * 255).round()),
                  valueColor: AlwaysStoppedAnimation<Color>(UiConstants.primaryButtonColor),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Stats row
          Row(
            children: [
              Expanded(child: _statItem(Icons.code, 'Easy', '18')),
              Expanded(child: _statItem(Icons.trending_up, 'Medium', '16')),
              Expanded(child: _statItem(Icons.bolt, 'Hard', '8')),
            ],
          ),

          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerRight,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextButton.icon(
                  onPressed: () => _shareProgress(context, progress, problemsSolved, totalProblems, currentStreak),
                  icon: const Icon(Icons.share, size: 18),
                  label: const Text('Share'),
                ),
                const SizedBox(width: 8),
                OutlinedButton.icon(
                  onPressed: () => _showDetails(context, progress, problemsSolved, totalProblems, currentStreak),
                  icon: const Icon(Icons.info_outline, size: 18),
                  label: const Text('Details'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _statItem(IconData icon, String label, String value) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 14, color: UiConstants.subtitleTextColor),
            const SizedBox(width: 6),
            Text(
              value,
              style: const TextStyle(
                color: UiConstants.mainTextColor,
                fontSize: 16,
                fontWeight: FontWeight.w900,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            color: UiConstants.subtitleTextColor,
            fontSize: 11,
            ),
        ),
      ],
    );
  }

  Future<void> _shareProgress(BuildContext context, double progress, int solved, int total, int streak) async {
    final percent = (progress * 100).round();
    final summary = 'Streak: $streak days\nSolved: $solved/$total ($percent%)';
    await Clipboard.setData(ClipboardData(text: summary));
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Progress copied to clipboard')));
  }

  void _showDetails(BuildContext context, double progress, int solved, int total, int streak) {
    final percent = (progress * 100).round();
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Progress Details'),
        content: Text('Current streak: $streak days\nProblems solved: $solved/$total ($percent%)'),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Close')),
        ],
      ),
    );
  }
}
