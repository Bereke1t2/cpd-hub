import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lab_portal/core/di/injection.dart';
import 'package:lab_portal/core/routing/route_names.dart';
import 'package:lab_portal/core/theme/app_spacing.dart';
import 'package:lab_portal/core/theme/app_text_styles.dart';
import 'package:lab_portal/core/ui_constants.dart';
import 'package:lab_portal/core/widgets/ui_kit.dart';
import 'package:lab_portal/features/auth/presentation/bloc/session/session_bloc.dart';
import 'package:lab_portal/features/settings/presentation/cubit/settings_cubit.dart';
import 'package:lab_portal/future/main/presentation/page/base_page.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: getIt<SettingsCubit>(),
      child: BasePage(
      title: 'Settings',
      subtitle: 'Account & preferences',
      selectedIndex: 5, // Profile tab
      body: ListView(
        padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md, vertical: AppSpacing.sm),
        children: [
          // ── Account ───────────────────────────────────────────────────
          const SectionHeader('Account', icon: Icons.person_outline_rounded),
          const SizedBox(height: AppSpacing.xs),
          GradientCard(
            child: Column(
              children: [
                _SettingsTile(
                  icon: Icons.edit_outlined,
                  title: 'Edit profile',
                  subtitle: 'Name, bio, avatar',
                  onTap: () {},
                ),
                const Divider(color: UiConstants.borderColor, height: 1),
                _SettingsTile(
                  icon: Icons.lock_outline_rounded,
                  title: 'Change password',
                  subtitle: 'Update your account password',
                  onTap: () {},
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.sm),

          // ── Practice ──────────────────────────────────────────────────
          const SectionHeader('Practice',
              icon: Icons.auto_awesome_rounded),
          const SizedBox(height: AppSpacing.xs),
          GradientCard(
            accent: UiConstants.ratingTextColor,
            child: Column(
              children: [
                _SettingsTile(
                  icon: Icons.emoji_events_rounded,
                  title: 'Weekly goal',
                  subtitle: 'Set how many problems to solve per week',
                  onTap: () =>
                      Navigator.pushNamed(context, RouteNames.consistency),
                ),
                const Divider(color: UiConstants.borderColor, height: 1),
                _SettingsTile(
                  icon: Icons.school_rounded,
                  title: 'Learning tracks',
                  subtitle: 'View curated CP learning paths',
                  onTap: () =>
                      Navigator.pushNamed(context, RouteNames.tracks),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.sm),

          // ── Notifications ─────────────────────────────────────────────
          const SectionHeader('Notifications',
              icon: Icons.notifications_outlined),
          const SizedBox(height: AppSpacing.xs),
          BlocBuilder<SettingsCubit, SettingsState>(
            builder: (context, state) {
              final cubit = context.read<SettingsCubit>();
              return GradientCard(
                child: Column(
                  children: [
                    _ToggleTile(
                      icon: Icons.alarm_rounded,
                      title: 'Daily practice reminder',
                      subtitle: 'Remind me to keep my streak alive',
                      value: state.dailyReminder,
                      onChanged: cubit.setDailyReminder,
                    ),
                    const Divider(color: UiConstants.borderColor, height: 1),
                    _ToggleTile(
                      icon: Icons.emoji_events_outlined,
                      title: 'Contest alerts',
                      subtitle: 'Notify before upcoming contests start',
                      value: state.contestAlerts,
                      onChanged: cubit.setContestAlerts,
                    ),
                  ],
                ),
              );
            },
          ),
          const SizedBox(height: AppSpacing.sm),

          // ── Appearance ────────────────────────────────────────────────
          const SectionHeader('Appearance',
              icon: Icons.palette_outlined),
          const SizedBox(height: AppSpacing.xs),
          GradientCard(
            child: _SettingsTile(
              icon: Icons.dark_mode_outlined,
              title: 'Theme',
              subtitle: 'Dark (default) — light theme coming soon',
              onTap: () {},
              trailing: const Icon(Icons.info_outline_rounded,
                  size: 16, color: UiConstants.subtitleTextColor),
            ),
          ),
          const SizedBox(height: AppSpacing.sm),

          // ── About ─────────────────────────────────────────────────────
          const SectionHeader('About', icon: Icons.info_outline_rounded),
          const SizedBox(height: AppSpacing.xs),
          GradientCard(
            child: Column(
              children: [
                _SettingsTile(
                  icon: Icons.help_outline_rounded,
                  title: 'Help & Support',
                  subtitle: 'About the app, my story & getting help',
                  onTap: () =>
                      Navigator.pushNamed(context, RouteNames.helpSupport),
                ),
                const Divider(color: UiConstants.borderColor, height: 1),
                _SettingsTile(
                  icon: Icons.code_rounded,
                  title: 'CPD Hub',
                  subtitle: 'Version 1.0.0 — Competitive Programming Division',
                  onTap: () {},
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.lg),

          // ── Sign out ──────────────────────────────────────────────────
          FilledButton.icon(
            style: FilledButton.styleFrom(
              backgroundColor: Colors.red.shade700,
              minimumSize: const Size(double.infinity, 52),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14)),
            ),
            onPressed: () => _confirmSignOut(context),
            icon: const Icon(Icons.logout_rounded, color: Colors.white),
            label: const Text(
              'Sign out',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w700),
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
        ],
      ),
      ),
    );
  }

  void _confirmSignOut(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: UiConstants.infoBackgroundColor,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Sign out?',
            style: TextStyle(color: UiConstants.mainTextColor)),
        content: const Text(
          'You will be returned to the login screen.',
          style: TextStyle(color: UiConstants.subtitleTextColor),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel',
                style: TextStyle(color: UiConstants.subtitleTextColor)),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
                backgroundColor: Colors.red.shade700),
            onPressed: () {
              // Close the dialog first, then clear the whole nav stack so
              // the WelcomePage in _AuthGate can surface cleanly.
              Navigator.pop(ctx);
              Navigator.of(context)
                  .popUntil((route) => route.isFirst);
              context
                  .read<SessionBloc>()
                  .add(const SessionLoggedOut());
            },
            child: const Text('Sign out',
                style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final Widget? trailing;

  const _SettingsTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm, vertical: 2),
      leading: Icon(icon, color: UiConstants.primaryButtonColor),
      title: Text(title, style: AppTextStyles.title),
      subtitle: Text(subtitle, style: AppTextStyles.caption),
      trailing: trailing ??
          const Icon(Icons.chevron_right_rounded,
              color: UiConstants.subtitleTextColor),
      onTap: onTap,
    );
  }
}

class _ToggleTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _ToggleTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm, vertical: 2),
      leading: Icon(icon, color: UiConstants.primaryButtonColor),
      title: Text(title, style: AppTextStyles.title),
      subtitle: Text(subtitle, style: AppTextStyles.caption),
      trailing: Switch(
        value: value,
        activeThumbColor: UiConstants.primaryButtonColor,
        activeTrackColor: UiConstants.primaryButtonColor.withValues(alpha: 0.45),
        onChanged: onChanged,
      ),
    );
  }
}
