import 'package:flutter/material.dart';
import 'package:lab_portal/future/main/presentation/page/base_page.dart';

import '../../../../core/ui_constants.dart';
import '../widget/info_section.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

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
          color: UiConstants.primaryButtonColor.withOpacity(0.12),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: UiConstants.primaryButtonColor.withOpacity(0.25),
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
              color: Colors.black.withOpacity(0.10),
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
                  color: UiConstants.primaryButtonColor.withOpacity(0.12),
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
                          backgroundColor:
                              UiConstants.primaryButtonColor.withOpacity(0.18),
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
                                color: UiConstants.primaryButtonColor
                                    .withOpacity(0.08),
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(
                                  color: UiConstants.primaryButtonColor
                                      .withOpacity(0.18),
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
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
