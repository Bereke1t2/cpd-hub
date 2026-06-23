import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:lab_portal/core/theme/app_spacing.dart';
import 'package:lab_portal/core/theme/app_text_styles.dart';
import 'package:lab_portal/core/ui_constants.dart';
import 'package:lab_portal/core/widgets/ui_kit.dart';
import 'package:lab_portal/future/main/presentation/page/base_page.dart';

/// Help & Support — also the app's "About" surface. Carries a short story
/// about the maker, the basics of getting help, and quick contact links.
class HelpSupportPage extends StatelessWidget {
  const HelpSupportPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BasePage(
      title: 'Help & Support',
      subtitle: 'About the app & getting help',
      selectedIndex: 5, // Profile tab
      body: ListView(
        padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md, vertical: AppSpacing.sm),
        children: const [
          _MakerCard(),
          SizedBox(height: AppSpacing.sm),

          SectionHeader('My story', icon: Icons.auto_stories_rounded),
          SizedBox(height: AppSpacing.xs),
          _StoryCard(),
          SizedBox(height: AppSpacing.sm),

          SectionHeader('Get help', icon: Icons.help_outline_rounded),
          SizedBox(height: AppSpacing.xs),
          _HelpCard(),
          SizedBox(height: AppSpacing.sm),

          SectionHeader('Reach me', icon: Icons.alternate_email_rounded),
          SizedBox(height: AppSpacing.xs),
          _ContactCard(),
          SizedBox(height: AppSpacing.lg),

          Center(
            child: Text(
              'CPD Hub · Version 1.0.0\nMade with care by Bereket Aschalew',
              textAlign: TextAlign.center,
              style: AppTextStyles.micro,
            ),
          ),
          SizedBox(height: AppSpacing.xl),
        ],
      ),
    );
  }
}

/// Hero card introducing the maker.
class _MakerCard extends StatelessWidget {
  const _MakerCard();

  @override
  Widget build(BuildContext context) {
    return GradientCard(
      child: Row(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                colors: [
                  UiConstants.primaryButtonColor,
                  UiConstants.primaryDark,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            alignment: Alignment.center,
            child: const Text(
              'BA',
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Bereket Aschalew', style: AppTextStyles.h2),
                SizedBox(height: 2),
                Text(
                  'Developer & competitive programmer',
                  style: AppTextStyles.caption,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// A short, simple story.
class _StoryCard extends StatelessWidget {
  const _StoryCard();

  @override
  Widget build(BuildContext context) {
    return const GradientCard(
      child: Text(
        "Hi, I'm Bereket. I fell for competitive programming the day a single "
        "clever idea turned an impossible problem into a few clean lines of "
        "code — and I've been chasing that feeling ever since.\n\n"
        "I built CPD Hub because practice felt scattered: problems in one "
        "place, contests in another, progress nowhere. I wanted one calm home "
        "where you can solve, track your streak, and actually watch yourself "
        "get better.\n\n"
        "This app is still growing, and so am I. Thanks for being part of the "
        "journey. Keep solving. 🚀",
        style: AppTextStyles.body,
      ),
    );
  }
}

/// Common help topics.
class _HelpCard extends StatelessWidget {
  const _HelpCard();

  @override
  Widget build(BuildContext context) {
    return const GradientCard(
      child: Column(
        children: [
          _InfoTile(
            icon: Icons.play_circle_outline_rounded,
            title: 'Getting started',
            subtitle: 'Pick a track, solve daily, keep your streak alive.',
          ),
          Divider(color: UiConstants.borderColor, height: 1),
          _InfoTile(
            icon: Icons.bug_report_outlined,
            title: 'Found a bug?',
            subtitle: 'Tell me what happened and I\'ll fix it fast.',
          ),
          Divider(color: UiConstants.borderColor, height: 1),
          _InfoTile(
            icon: Icons.lightbulb_outline_rounded,
            title: 'Have an idea?',
            subtitle: 'Feature requests are always welcome.',
          ),
        ],
      ),
    );
  }
}

/// Contact links — each opens the relevant app/browser.
class _ContactCard extends StatelessWidget {
  const _ContactCard();

  @override
  Widget build(BuildContext context) {
    return GradientCard(
      child: Column(
        children: [
          _InfoTile(
            icon: Icons.email_outlined,
            title: 'Email',
            subtitle: 'bereketaschalew@gmail.com',
            onTap: () => _open('mailto:bereketaschalew@gmail.com'),
          ),
          const Divider(color: UiConstants.borderColor, height: 1),
          _InfoTile(
            icon: Icons.send_rounded,
            title: 'Telegram',
            subtitle: '@Brahmajnana_sophos',
            onTap: () => _open('https://t.me/Brahmajnana_sophos'),
          ),
          const Divider(color: UiConstants.borderColor, height: 1),
          _InfoTile(
            icon: Icons.code_rounded,
            title: 'GitHub',
            subtitle: 'github.com/bereke1t2',
            onTap: () => _open('https://github.com/bereke1t2'),
          ),
        ],
      ),
    );
  }

  Future<void> _open(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}

class _InfoTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback? onTap;

  const _InfoTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm, vertical: 2),
      leading: Icon(icon, color: UiConstants.primaryButtonColor),
      title: Text(title, style: AppTextStyles.title),
      subtitle: Text(subtitle, style: AppTextStyles.caption),
      trailing: onTap == null
          ? null
          : const Icon(Icons.open_in_new_rounded,
              size: 16, color: UiConstants.subtitleTextColor),
      onTap: onTap,
    );
  }
}
