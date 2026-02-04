// filepath: /home/bereket/lab/cpd/CPD_HUB/lib/future/main/presentation/page/profile_page.dart
import 'package:flutter/material.dart';
import 'package:lab_portal/future/main/presentation/page/base_page.dart';
import 'package:flutter/services.dart';

import '../../../../core/ui_constants.dart';
import '../widget/info_section.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late List<int> recentActivity;

  List<int> generateMockActivity(int days) {
    final List<int> out = List.filled(days, 0);
    for (var i = 0; i < days; i++) {
      final weekday = DateTime.now().subtract(Duration(days: days - 1 - i)).weekday;
      if (i % 6 == 0 || i % 3 == 0) out[i] = 1;
      if (weekday == DateTime.tuesday || weekday == DateTime.thursday) out[i] += 1;
    }
    return out;
  }

  @override
  void initState() {
    super.initState();
    recentActivity = generateMockActivity(35);
  }

  void _toggleToday() {
    setState(() {
      if (recentActivity.isEmpty) return;
      final last = recentActivity.length - 1;
      recentActivity[last] = recentActivity[last] > 0 ? 0 : 1;
    });
  }

  void _copySummaryToClipboard() {
    final activeDays = recentActivity.where((d) => d > 0).length;
    final total = recentActivity.length;
    final percent = total == 0 ? 0 : ((activeDays / total) * 100).round();
    // compute longest streak
    var max = 0, cur = 0;
    for (final v in recentActivity) {
      if (v > 0) {
        cur += 1;
        if (cur > max) max = cur;
      } else {
        cur = 0;
      }
    }
    final longest = max;

    final summary = 'John Doe • Rating: 1500 • Solved: 120 • Active: $percent% in last $total days • Longest streak: $longest days';
    Clipboard.setData(ClipboardData(text: summary));
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Profile summary copied to clipboard')));
  }

  @override
  Widget build(BuildContext context) {
    // Mocked profile (until profile is moved to data layer like other features)
    const name = 'John Doe';
    const status = 'Active';
    const email = 'john.doe@labportal.dev';
    const department = 'Computer Science';

    Widget actionChip({required IconData icon, required String label}) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: UiConstants.primaryButtonColor.withAlpha((0.12 * 255).round()),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: UiConstants.primaryButtonColor.withAlpha((0.25 * 255).round()),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 18, color: UiConstants.primaryButtonColor),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: UiConstants.primaryButtonColor,
              ),
            ),
          ],
        ),
      );
    }

    Widget card({required Widget child}) {
      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 16.0),
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: UiConstants.infoBackgroundColor,
          borderRadius: BorderRadius.circular(16.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha((0.10 * 255).round()),
              blurRadius: 10.0,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: child,
      );
    }

    Widget settingRow({
      required IconData icon,
      required String title,
      String? subtitle,
      VoidCallback? onTap,
    }) {
      return InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: UiConstants.primaryButtonColor.withAlpha((0.12 * 255).round()),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  size: 20,
                  color: UiConstants.primaryButtonColor,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: UiConstants.mainTextColor,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                    if (subtitle != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: UiConstants.subtitleTextColor,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: 8),
              const Icon(
                Icons.chevron_right,
                color: UiConstants.subtitleTextColor,
              ),
            ],
          ),
        ),
      );
    }

    return BasePage(
      title: 'Profile',
      subtitle: 'Track your learning & progress',
      selectedIndex: 4,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 12, bottom: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              card(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          radius: 28,
                          backgroundColor: UiConstants.primaryButtonColor.withAlpha((0.18 * 255).round()),
                          child: const Icon(
                            Icons.person,
                            size: 30,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text(
                                name,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                  color: UiConstants.mainTextColor,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                email,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: UiConstants.subtitleTextColor,
                                ),
                              ),
                              SizedBox(height: 6),
                              Text(
                                status,
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  color: UiConstants.primaryButtonColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: [
                        actionChip(icon: Icons.edit, label: 'Edit'),
                        actionChip(icon: Icons.badge_outlined, label: department),
                        actionChip(icon: Icons.workspace_premium, label: 'Badges'),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              const InfoSection(
                division: 1,
                rating: '1500',
                rank: 'Gold',
                solvedProblems: 120,
              ),
              const SizedBox(height: 14),
              card(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Learning overview',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: UiConstants.mainTextColor,
                      ),
                    ),
                    const SizedBox(height: 12),
                    LayoutBuilder(
                      builder: (context, constraints) {
                        final isWide = constraints.maxWidth >= 520;
                        final itemWidth = isWide
                            ? (constraints.maxWidth - 12) / 2
                            : constraints.maxWidth;

                        Widget miniStat({
                          required IconData icon,
                          required String title,
                          required String value,
                        }) {
                          return SizedBox(
                            width: itemWidth,
                            child: Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: UiConstants.primaryButtonColor.withAlpha((0.08 * 255).round()),
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(
                                  color: UiConstants.primaryButtonColor.withAlpha((0.18 * 255).round()),
                                ),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    icon,
                                    size: 20,
                                    color: UiConstants.primaryButtonColor,
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          title,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            fontSize: 12,
                                            color: UiConstants.subtitleTextColor,
                                          ),
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          value,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w700,
                                            color: UiConstants.mainTextColor,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }

                        return Wrap(
                          spacing: 12,
                          runSpacing: 12,
                          children: [
                            miniStat(
                              icon: Icons.calendar_month_outlined,
                              title: 'Weekly activity',
                              value: '3 sessions',
                            ),
                            miniStat(
                              icon: Icons.local_fire_department_outlined,
                              title: 'Streak',
                              value: '5 days',
                            ),
                            miniStat(
                              icon: Icons.done_all,
                              title: 'Solved this week',
                              value: '7 problems',
                            ),
                            miniStat(
                              icon: Icons.timer_outlined,
                              title: 'Avg. time / problem',
                              value: '18 min',
                            ),
                          ],
                        );
                      },
                    ),
                    const SizedBox(height: 12),
                    // small sparkline showing recent activity (last 14 days)
                    Builder(builder: (context) {
                      final list = recentActivity.length >= 14 ? recentActivity.sublist(recentActivity.length - 14) : recentActivity;
                      return _MiniSparkline(data: list);
                    }),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              // Consistency visualization + small board
              card(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Expanded(
                          child: Text(
                            'Consistency',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: UiConstants.mainTextColor,
                            ),
                          ),
                        ),
                        // action to toggle today's solved state
                        TextButton.icon(
                          onPressed: _toggleToday,
                          icon: const Icon(Icons.today, size: 18),
                          label: Text(recentActivity.isNotEmpty && recentActivity.last > 0 ? 'Unmark today' : 'Mark today'),
                          style: TextButton.styleFrom(
                            foregroundColor: UiConstants.primaryButtonColor,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    // Graph and board side-by-side on wide screens
                    LayoutBuilder(builder: (context, constraints) {
                      final isWide = constraints.maxWidth >= 640;

                      return isWide
                          ? Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(flex: 3, child: _ConsistencyGraph(data: recentActivity)),
                                const SizedBox(width: 12),
                                Expanded(flex: 2, child: _ConsistencyBoard(data: recentActivity)),
                              ],
                            )
                          : Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _ConsistencyGraph(data: recentActivity),
                                const SizedBox(height: 10),
                                _ConsistencyBoard(data: recentActivity),
                              ],
                            );
                    }),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              card(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Settings',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: UiConstants.mainTextColor,
                      ),
                    ),
                    const SizedBox(height: 8),
                    settingRow(
                      icon: Icons.notifications_none,
                      title: 'Notifications',
                      subtitle: 'Daily reminder, contest alerts',
                      onTap: () {},
                    ),
                    const Divider(color: Colors.white12),
                    settingRow(
                      icon: Icons.privacy_tip_outlined,
                      title: 'Privacy',
                      subtitle: 'Profile visibility and data',
                      onTap: () {},
                    ),
                    const Divider(color: Colors.white12),
                    settingRow(
                      icon: Icons.help_outline,
                      title: 'Help & feedback',
                      subtitle: 'Report bugs or suggest features',
                      onTap: () {},
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ConsistencyGraph extends StatelessWidget {
  final List<int> data; // data oldest -> newest

  const _ConsistencyGraph({required this.data});

  Color _colorForValue(int v) {
    if (v <= 0) return const Color(0xFFEBEDF0); // empty (GitHub light gray)
    if (v == 1) return const Color(0xFFB7EFC0); // light green
    if (v == 2) return const Color(0xFF6FD36F); // medium
    return const Color(0xFF2EB82E); // strong
  }

  String _monthLabelForIndex(int idx, int days) {
    final date = DateTime.now().subtract(Duration(days: days - 1 - idx));
    if (date.day <= 3) {
      return '${_monthAbbr(date.month)}';
    }
    return '';
  }

  String _monthAbbr(int m) {
    const months = ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'];
    return months[m-1];
  }

  @override
  Widget build(BuildContext context) {
    final days = data.length;
    final cols = (days / 7).ceil();

    return LayoutBuilder(builder: (context, constraints) {
      final spacing = 6.0;
      final squareSize = ((constraints.maxWidth - (cols - 1) * spacing) / cols).clamp(12.0, 28.0);

      final List<Widget> columns = List.generate(cols, (c) {
        final startIndex = c * 7;
        final List<Widget> colChildren = [];
        for (var r = 0; r < 7; r++) {
          final idx = startIndex + r;
          final value = (idx < days) ? data[idx] : 0;
          final date = DateTime.now().subtract(Duration(days: days - 1 - idx));
          final formatted = '${date.year}-${date.month.toString().padLeft(2, "0")}-${date.day.toString().padLeft(2, "0")}';

          colChildren.add(Tooltip(
            message: value > 0 ? '$value solved on $formatted' : 'No activity on $formatted',
            child: InkWell(
              borderRadius: BorderRadius.circular(6),
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(value > 0 ? '$value solved on $formatted' : 'No activity on $formatted'), duration: const Duration(milliseconds: 900)));
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 240),
                margin: EdgeInsets.only(bottom: r == 6 ? 0 : 6),
                width: squareSize,
                height: squareSize,
                decoration: BoxDecoration(
                  color: _colorForValue(value),
                  borderRadius: BorderRadius.circular(6),
                  border: value > 0 ? Border.all(color: Colors.black.withAlpha((0.06 * 255).round())) : Border.all(color: Colors.transparent),
                  boxShadow: value > 0 ? [BoxShadow(color: Colors.black.withAlpha((0.04 * 255).round()), blurRadius: 6, offset: const Offset(0, 2))] : null,
                ),
                transform: value > 0 ? Matrix4.identity()..scale(1.02) : null,
              ),
            ),
          ));
        }

        return Column(
          mainAxisSize: MainAxisSize.min,
          children: colChildren,
        );
      });

      final monthLabels = List<Widget>.generate(cols, (c) {
        final idx = c * 7;
        final label = _monthLabelForIndex(idx, days);
        return SizedBox(
          width: squareSize,
          child: Center(
            child: Text(label, style: const TextStyle(fontSize: 11, color: UiConstants.subtitleTextColor)),
          ),
        );
      });

      final showWeekLabels = constraints.maxWidth >= 480;
      final weekdayNames = ['S','M','T','W','T','F','S'];

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text('Last ${data.length} days', style: const TextStyle(fontWeight: FontWeight.w700, color: UiConstants.mainTextColor)),
              const SizedBox(width: 12),
              const Text('Less', style: TextStyle(fontSize: 12, color: UiConstants.subtitleTextColor)),
              const SizedBox(width: 6),
              Container(width: 12, height: 12, color: const Color(0xFFEBEDF0)),
              const SizedBox(width: 6),
              Container(width: 12, height: 12, color: const Color(0xFFB7EFC0)),
              const SizedBox(width: 6),
              Container(width: 12, height: 12, color: const Color(0xFF2EB82E)),
              const SizedBox(width: 6),
              const Text('More', style: TextStyle(fontSize: 12, color: UiConstants.subtitleTextColor)),
            ],
          ),
          const SizedBox(height: 10),

          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (showWeekLabels)
                  Column(
                    children: weekdayNames.map((d) => SizedBox(height: squareSize, width: 20, child: Center(child: Text(d, style: const TextStyle(fontSize: 11, color: UiConstants.subtitleTextColor))))).toList(),
                  ),
                const SizedBox(width: 8),
                Column(
                  children: [
                    Row(children: monthLabels.map((w) => Padding(padding: const EdgeInsets.only(right: 6), child: w)).toList()),
                    const SizedBox(height: 6),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: columns
                          .map((col) => Padding(
                                padding: EdgeInsets.only(right: columns.last == col ? 0 : spacing),
                                child: col,
                              ))
                          .toList(),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      );
    });
  }
}

class _ConsistencyBoard extends StatelessWidget {
  final List<int> data;

  const _ConsistencyBoard({required this.data});

  int _longestStreak(List<int> arr) {
    var max = 0, cur = 0;
    for (final v in arr) {
      if (v > 0) {
        cur += 1;
        if (cur > max) max = cur;
      } else {
        cur = 0;
      }
    }
    return max;
  }

  @override
  Widget build(BuildContext context) {
    final activeDays = data.where((d) => d > 0).length;
    final total = data.length;
    final inactiveDays = total - activeDays;
    final percent = total == 0 ? 0 : ((activeDays / total) * 100).round();
    final longest = _longestStreak(data);

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: UiConstants.primaryButtonColor.withAlpha((0.08 * 255).round()),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: UiConstants.primaryButtonColor.withAlpha((0.18 * 255).round()),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Active days: $activeDays',
            style: const TextStyle(
              fontSize: 12,
              color: UiConstants.mainTextColor,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Inactive days: $inactiveDays',
            style: const TextStyle(
              fontSize: 12,
              color: UiConstants.mainTextColor,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Longest streak: $longest days',
            style: const TextStyle(
              fontSize: 12,
              color: UiConstants.mainTextColor,
            ),
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: activeDays / (total == 0 ? 1 : total),
              minHeight: 10,
              backgroundColor: UiConstants.primaryButtonColor.withAlpha((0.12 * 255).round()),
              valueColor: AlwaysStoppedAnimation<Color>(UiConstants.primaryButtonColor),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '$percent% active in the last $total days',
            style: const TextStyle(
              fontSize: 12,
              color: UiConstants.subtitleTextColor,
            ),
          ),
        ],
      ),
    );
  }
}

// mini sparkline widget
class _MiniSparkline extends StatelessWidget {
  final List<int> data; // small array, newest last
  const _MiniSparkline({required this.data});

  @override
  Widget build(BuildContext context) {
    final colors = [const Color(0xFFEBEDF0), const Color(0xFFB7EFC0), const Color(0xFF6FD36F), const Color(0xFF2EB82E)];
    final maxVal = data.isEmpty ? 1 : data.reduce((a, b) => a > b ? a : b);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
      decoration: BoxDecoration(
        color: UiConstants.primaryButtonColor.withAlpha((0.04 * 255).round()),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: data.map((v) {
          final h = (v / (maxVal == 0 ? 1 : maxVal)) * 28 + 6; // height between 6..34
          final c = (v <= 0) ? colors[0] : (v == 1 ? colors[1] : (v == 2 ? colors[2] : colors[3]));
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 3),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 240),
              width: 8,
              height: h,
              decoration: BoxDecoration(color: c, borderRadius: BorderRadius.circular(3)),
            ),
          );
        }).toList(),
      ),
    );
  }
}
