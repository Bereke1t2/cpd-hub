import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lab_portal/core/di/injection.dart';
import 'package:lab_portal/core/theme/app_dimens.dart';
import 'package:lab_portal/core/ui_constants.dart';
import 'package:lab_portal/features/consistency/presentation/cubit/streak/streak_cubit.dart';
import 'package:lab_portal/features/learning/domain/entity/topic_entity.dart';
import 'package:lab_portal/features/learning/domain/service/learning_path_engine.dart';
import 'package:lab_portal/features/learning/presentation/bloc/topics/topics_bloc.dart';
import 'package:lab_portal/features/practice/domain/service/strength_analyzer.dart';
import 'package:lab_portal/features/practice/domain/entity/solve_history.dart';
import 'package:lab_portal/features/practice/presentation/widget/strength_category_bar.dart';
import 'package:lab_portal/future/main/presentation/bloc/profile/profile_bloc.dart';
import 'package:lab_portal/future/main/presentation/page/base_page.dart';

// ── Constants ──────────────────────────────────────────────────────────────────
const _green = UiConstants.primaryButtonColor;
const _surface = UiConstants.infoBackgroundColor;
const _white = UiConstants.mainTextColor;
const _muted = UiConstants.subtitleTextColor;

BoxDecoration get _card => BoxDecoration(
      color: _surface,
      borderRadius: AppDimens.brLg,
      border: Border.all(color: _green.withValues(alpha: 0.15)),
    );

// ── Page ───────────────────────────────────────────────────────────────────────
class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
            create: (_) => getIt<ProfileBloc>()..add(const ProfileStarted())),
        BlocProvider.value(value: getIt<StreakCubit>()..load()),
      ],
      child: BlocBuilder<ProfileBloc, ProfileState>(
        builder: (context, state) {
          final int rating;
          final String rank, division, fullName, username, bio;

          if (state is ProfileLoaded) {
            rating = state.user.rating;
            rank = state.user.rank;
            division = state.user.division;
            fullName = state.user.fullName;
            username = state.user.username;
            bio = state.user.bio;
          } else {
            rating = 0;
            rank = '—';
            division = '—';
            fullName = state is ProfileLoading ? 'Loading…' : 'Profile';
            username = '';
            bio = '';
          }

          final streakState = context.watch<StreakCubit>().state;
          final activeDays = streakState is StreakLoaded
              ? streakState.streak.activeDays
              : <DateTime>[];
          final today = DateTime.now();
          const days = 168;
          final attendance = List<int>.generate(days, (i) {
            final d = DateTime(
                today.year, today.month, today.day - (days - 1 - i));
            return activeDays.any((a) =>
                    a.year == d.year &&
                    a.month == d.month &&
                    a.day == d.day)
                ? 1
                : 0;
          });
          final contributions = _mockContributions(days);
          final ratingHistory = <int>[
            1180, 1210, 1260, 1290, 1330, 1380,
            1410, 1470, 1490, 1510, 1500, rating
          ];

          return BasePage(
            title: 'Profile',
            subtitle: '',
            selectedIndex: 5,
            body: CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                // ── Hero ────────────────────────────────────────────────────
                SliverToBoxAdapter(
                  child: _HeroHeader(
                    fullName: fullName,
                    username: username,
                    bio: bio,
                    rating: rating,
                    rank: rank,
                    division: division,
                  ),
                ),

                // ── Stats grid ───────────────────────────────────────────────
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(
                        AppDimens.lg, AppDimens.lg, AppDimens.lg, 0),
                    child: _StatsGrid(rating: rating),
                  ),
                ),

                // ── Activity heatmap ─────────────────────────────────────────
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(
                        AppDimens.lg, AppDimens.lg, AppDimens.lg, 0),
                    child: _ActivityCard(
                      contributions: contributions,
                      attendance: attendance,
                    ),
                  ),
                ),

                // ── Rating graph ─────────────────────────────────────────────
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(
                        AppDimens.lg, AppDimens.lg, AppDimens.lg, 0),
                    child: _RatingCard(
                      history: ratingHistory,
                      current: rating,
                    ),
                  ),
                ),

                // ── Recent contests ───────────────────────────────────────────
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(
                        AppDimens.lg, AppDimens.lg, AppDimens.lg, 0),
                    child: const _RecentContestsCard(),
                  ),
                ),

                // ── Achievements ──────────────────────────────────────────────
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(
                        AppDimens.lg, AppDimens.lg, AppDimens.lg, 0),
                    child: const _AchievementsCard(),
                  ),
                ),

                // ── Account ───────────────────────────────────────────────────
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(
                        AppDimens.lg, AppDimens.lg, AppDimens.lg, AppDimens.xl + 80),
                    child: const _AccountCard(),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  static List<int> _mockContributions(int days) {
    final rnd = Random(42);
    return List<int>.generate(days, (i) {
      final base = (sin(i / 7) * 3).round();
      final noise = rnd.nextInt(3);
      return max(0, base + noise + (i % 6 == 0 ? rnd.nextInt(3) : 0));
    });
  }
}

// ── Hero header ────────────────────────────────────────────────────────────────
class _HeroHeader extends StatelessWidget {
  final String fullName, username, bio, rank, division;
  final int rating;

  const _HeroHeader({
    required this.fullName,
    required this.username,
    required this.bio,
    required this.rating,
    required this.rank,
    required this.division,
  });

  String _initials() {
    if (fullName.isEmpty) return 'U';
    final parts = fullName.trim().split(RegExp(r'\s+'));
    if (parts.length == 1) {
      return parts[0].substring(0, min(2, parts[0].length)).toUpperCase();
    }
    return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(AppDimens.lg),
      padding: const EdgeInsets.all(AppDimens.lg),
      decoration: BoxDecoration(
        // Muted deep-green → surface so the box sits in the same tonal range
        // as the cards below instead of glowing brighter than everything else.
        gradient: const LinearGradient(
          colors: [UiConstants.primaryDark, _surface],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: AppDimens.brLg,
        border: Border.all(color: _green.withValues(alpha: 0.18)),
        boxShadow: const [
          BoxShadow(
            color: UiConstants.shadowColor,
            blurRadius: 16,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Avatar + share button row
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(3),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.25),
                ),
                child: CircleAvatar(
                  radius: 30,
                  backgroundColor: UiConstants.primaryDark,
                  child: Text(
                    _initials(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: AppDimens.fH2,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ),
              const Spacer(),
              _ActionBtn(
                icon: Icons.ios_share_outlined,
                onTap: () {},
              ),
              const SizedBox(width: AppDimens.sm),
              _ActionBtn(
                icon: Icons.edit_outlined,
                onTap: () {},
              ),
            ],
          ),
          const SizedBox(height: AppDimens.md),
          // Name + username
          Text(
            fullName.isEmpty ? '—' : fullName,
            style: const TextStyle(
              color: Colors.white,
              fontSize: AppDimens.fH1,
              fontWeight: FontWeight.w900,
            ),
          ),
          if (username.isNotEmpty) ...[
            const SizedBox(height: AppDimens.xxs),
            Text(
              '@$username',
              style: const TextStyle(
                color: Colors.white70,
                fontSize: AppDimens.fBody,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
          const SizedBox(height: AppDimens.sm),
          // Bio
          Text(
            bio.isNotEmpty
                ? bio
                : 'Build consistency. Solve smarter every day.',
            style: const TextStyle(
              color: Colors.white70,
              fontSize: AppDimens.fBody,
              height: 1.4,
            ),
          ),
          const SizedBox(height: AppDimens.md),
          // Rating / Rank / Division pills
          Wrap(
            spacing: AppDimens.sm,
            runSpacing: AppDimens.sm,
            children: [
              _HeroPill(label: 'Rating', value: rating.toString()),
              _HeroPill(label: 'Rank', value: rank),
              _HeroPill(label: 'Division', value: division),
            ],
          ),
        ],
      ),
    );
  }
}

class _HeroPill extends StatelessWidget {
  final String label, value;
  const _HeroPill({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: AppDimens.md, vertical: AppDimens.xs),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.18),
        borderRadius: const BorderRadius.all(Radius.circular(AppDimens.rPill)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '$label  ',
            style: const TextStyle(
              color: Colors.white60,
              fontSize: AppDimens.fCaption,
              fontWeight: FontWeight.w700,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: AppDimens.fCaption,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _ActionBtn({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.18),
          borderRadius: AppDimens.brSm,
        ),
        child: Icon(icon, color: Colors.white, size: AppDimens.iconSm),
      ),
    );
  }
}

// ── Stats 2×2 grid ─────────────────────────────────────────────────────────────
class _StatsGrid extends StatelessWidget {
  final int rating;
  const _StatsGrid({required this.rating});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _SectionLabel('PERFORMANCE'),
        const SizedBox(height: AppDimens.sm),
        Row(
          children: [
            Expanded(
                child: _StatTile(
                    icon: Icons.check_circle_outline_rounded,
                    label: 'Solved',
                    value: '320')),
            const SizedBox(width: AppDimens.sm),
            Expanded(
                child: _StatTile(
                    icon: Icons.local_fire_department_outlined,
                    label: 'Streak',
                    value: '7d')),
          ],
        ),
        const SizedBox(height: AppDimens.sm),
        Row(
          children: [
            Expanded(
                child: _StatTile(
                    icon: Icons.emoji_events_outlined,
                    label: 'Contests',
                    value: '24')),
            const SizedBox(width: AppDimens.sm),
            Expanded(
                child: _StatTile(
                    icon: Icons.leaderboard_outlined,
                    label: 'Rank',
                    value: '#1,204')),
          ],
        ),
      ],
    );
  }
}

class _StatTile extends StatelessWidget {
  final IconData icon;
  final String label, value;
  const _StatTile({required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppDimens.md),
      decoration: _card,
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: _green.withValues(alpha: 0.12),
              borderRadius: AppDimens.brSm,
            ),
            child: Icon(icon, color: _green, size: AppDimens.iconMd),
          ),
          const SizedBox(width: AppDimens.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(value,
                    style: const TextStyle(
                      color: _white,
                      fontSize: AppDimens.fH2,
                      fontWeight: FontWeight.w900,
                    )),
                Text(label,
                    style: const TextStyle(
                      color: _muted,
                      fontSize: AppDimens.fCaption,
                    )),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Activity heatmap ───────────────────────────────────────────────────────────
class _ActivityCard extends StatefulWidget {
  final List<int> contributions;
  final List<int> attendance;
  const _ActivityCard(
      {required this.contributions, required this.attendance});

  @override
  State<_ActivityCard> createState() => _ActivityCardState();
}

class _ActivityCardState extends State<_ActivityCard> {
  int _tab = 0;

  @override
  Widget build(BuildContext context) {
    final values = _tab == 0 ? widget.contributions : widget.attendance;
    return Container(
      padding: const EdgeInsets.all(AppDimens.md),
      decoration: _card,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Expanded(
                  child: _SectionLabel('ACTIVITY')),
              // Segmented toggle
              Container(
                decoration: BoxDecoration(
                  color: _green.withValues(alpha: 0.10),
                  borderRadius: AppDimens.brSm,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _Tab(label: 'Contributions', selected: _tab == 0,
                        onTap: () => setState(() => _tab = 0)),
                    _Tab(label: 'Attendance', selected: _tab == 1,
                        onTap: () => setState(() => _tab = 1)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppDimens.md),
          SizedBox(
            height: 180,
            child: RepaintBoundary(
              child: ContributionHeatMap(
                values: values,
                primary: _green,
                isBinary: _tab == 1,
              ),
            ),
          ),
          const SizedBox(height: AppDimens.sm),
          // Legend
          Row(
            children: [
              const Text('Less',
                  style: TextStyle(color: _muted, fontSize: AppDimens.fMicro)),
              const SizedBox(width: AppDimens.sm),
              ...ContributionHeatMap.kLevels.map((c) => Padding(
                    padding: const EdgeInsets.only(right: AppDimens.xs),
                    child: Container(
                      width: 14,
                      height: 10,
                      decoration: BoxDecoration(
                        color: c,
                        borderRadius: const BorderRadius.all(Radius.circular(2)),
                        border: Border.all(
                            color: _green.withValues(alpha: 0.15)),
                      ),
                    ),
                  )),
              const Text('More',
                  style: TextStyle(color: _muted, fontSize: AppDimens.fMicro)),
            ],
          ),
        ],
      ),
    );
  }
}

class _Tab extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  const _Tab({required this.label, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(
            horizontal: AppDimens.sm, vertical: AppDimens.xs),
        decoration: BoxDecoration(
          color:
              selected ? _green : Colors.transparent,
          borderRadius: AppDimens.brSm,
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected ? Colors.white : _muted,
            fontSize: AppDimens.fCaption,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}

// ── Rating graph ───────────────────────────────────────────────────────────────
class _RatingCard extends StatelessWidget {
  final List<int> history;
  final int current;
  const _RatingCard({required this.history, required this.current});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppDimens.md),
      decoration: _card,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Expanded(child: _SectionLabel('RATING HISTORY')),
              Text(
                'Last ${history.length} contests',
                style: const TextStyle(
                  color: _muted,
                  fontSize: AppDimens.fCaption,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppDimens.md),
          SizedBox(
            height: 180,
            child: RepaintBoundary(
              child: RatingGraph(
                values: history,
                lineColor: _green,
                currentValue: current,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Recent contests ────────────────────────────────────────────────────────────
class _RecentContestsCard extends StatelessWidget {
  const _RecentContestsCard();

  @override
  Widget build(BuildContext context) {
    const contests = [
      ('Weekly Challenge #24', '2 days ago', '#45'),
      ('Sprint Round 12', '1 month ago', '#120'),
      ('Monthly Marathon', '3 months ago', '#320'),
    ];

    return Container(
      padding: const EdgeInsets.all(AppDimens.md),
      decoration: _card,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SectionLabel('RECENT CONTESTS'),
          const SizedBox(height: AppDimens.md),
          ...contests.map((c) => Padding(
                padding: const EdgeInsets.only(bottom: AppDimens.sm),
                child: _ContestRow(
                  title: c.$1,
                  when: c.$2,
                  rank: c.$3,
                ),
              )),
        ],
      ),
    );
  }
}

class _ContestRow extends StatelessWidget {
  final String title, when, rank;
  const _ContestRow(
      {required this.title, required this.when, required this.rank});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: AppDimens.md, vertical: AppDimens.sm),
      decoration: BoxDecoration(
        color: _green.withValues(alpha: 0.06),
        borderRadius: AppDimens.brMd,
        border: Border.all(color: _green.withValues(alpha: 0.12)),
      ),
      child: Row(
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: _green.withValues(alpha: 0.15),
              borderRadius: AppDimens.brSm,
            ),
            child: const Icon(Icons.emoji_events_outlined,
                color: _green, size: AppDimens.iconSm),
          ),
          const SizedBox(width: AppDimens.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                      color: _white,
                      fontWeight: FontWeight.w700,
                      fontSize: AppDimens.fBody,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis),
                Text(when,
                    style: const TextStyle(
                        color: _muted, fontSize: AppDimens.fCaption)),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(
                horizontal: AppDimens.sm, vertical: AppDimens.xxs),
            decoration: BoxDecoration(
              color: _green,
              borderRadius: AppDimens.brSm,
            ),
            child: Text(rank,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                  fontSize: AppDimens.fCaption,
                )),
          ),
        ],
      ),
    );
  }
}

// ── Achievements ───────────────────────────────────────────────────────────────
class _AchievementsCard extends StatelessWidget {
  const _AchievementsCard();

  @override
  Widget build(BuildContext context) {
    const badges = [
      (Icons.star_border_rounded, '100 Solves'),
      (Icons.local_fire_department_outlined, '7-day Streak'),
      (Icons.emoji_events_outlined, 'Top 10%'),
      (Icons.flag_outlined, 'First Contest'),
      (Icons.bolt_outlined, 'Speed Solver'),
    ];

    return Container(
      padding: const EdgeInsets.all(AppDimens.md),
      decoration: _card,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SectionLabel('ACHIEVEMENTS'),
          const SizedBox(height: AppDimens.md),
          Wrap(
            spacing: AppDimens.sm,
            runSpacing: AppDimens.sm,
            children: badges
                .map((b) => Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: AppDimens.md,
                          vertical: AppDimens.sm),
                      decoration: BoxDecoration(
                        color: _green.withValues(alpha: 0.10),
                        borderRadius: const BorderRadius.all(
                            Radius.circular(AppDimens.rPill)),
                        border: Border.all(
                            color: _green.withValues(alpha: 0.25)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(b.$1,
                              size: AppDimens.iconSm, color: _green),
                          const SizedBox(width: AppDimens.xs),
                          Text(b.$2,
                              style: const TextStyle(
                                color: _white,
                                fontSize: AppDimens.fCaption,
                                fontWeight: FontWeight.w700,
                              )),
                        ],
                      ),
                    ))
                .toList(),
          ),
        ],
      ),
    );
  }
}

// ── Account ────────────────────────────────────────────────────────────────────
class _AccountCard extends StatelessWidget {
  const _AccountCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppDimens.md),
      decoration: _card,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SectionLabel('ACCOUNT'),
          const SizedBox(height: AppDimens.md),
          // Settings tile
          _SettingsTile(
            icon: Icons.settings_outlined,
            title: 'Settings',
            subtitle: 'Notifications, appearance, privacy',
            onTap: () {},
          ),
          const SizedBox(height: AppDimens.sm),
          _SettingsTile(
            icon: Icons.help_outline_rounded,
            title: 'Help & Support',
            subtitle: 'FAQs, contact us',
            onTap: () {},
          ),
          const SizedBox(height: AppDimens.md),
          // Action buttons
          Row(
            children: [
              Expanded(
                child: _OutlineBtn(
                  icon: Icons.edit_outlined,
                  label: 'Edit Profile',
                  onTap: () {},
                ),
              ),
              const SizedBox(width: AppDimens.sm),
              Expanded(
                child: _OutlineBtn(
                  icon: Icons.logout_rounded,
                  label: 'Sign Out',
                  onTap: () {},
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title, subtitle;
  final VoidCallback onTap;
  const _SettingsTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
            horizontal: AppDimens.md, vertical: AppDimens.sm + 2),
        decoration: BoxDecoration(
          color: _green.withValues(alpha: 0.06),
          borderRadius: AppDimens.brMd,
          border: Border.all(color: _green.withValues(alpha: 0.12)),
        ),
        child: Row(
          children: [
            Icon(icon, color: _green, size: AppDimens.iconMd),
            const SizedBox(width: AppDimens.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: const TextStyle(
                        color: _white,
                        fontWeight: FontWeight.w700,
                        fontSize: AppDimens.fBody,
                      )),
                  Text(subtitle,
                      style: const TextStyle(
                          color: _muted, fontSize: AppDimens.fCaption)),
                ],
              ),
            ),
            const Icon(Icons.chevron_right_rounded,
                color: _muted, size: AppDimens.iconMd),
          ],
        ),
      ),
    );
  }
}

class _OutlineBtn extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  const _OutlineBtn(
      {required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: AppDimens.buttonHeight,
        decoration: BoxDecoration(
          borderRadius: AppDimens.brMd,
          border: Border.all(color: _green.withValues(alpha: 0.40)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: _green, size: AppDimens.iconSm),
            const SizedBox(width: AppDimens.xs),
            Text(label,
                style: const TextStyle(
                  color: _green,
                  fontWeight: FontWeight.w700,
                  fontSize: AppDimens.fBody,
                )),
          ],
        ),
      ),
    );
  }
}

// ── Shared label ───────────────────────────────────────────────────────────────
class _SectionLabel extends StatelessWidget {
  final String text;
  const _SectionLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        color: _muted,
        fontSize: AppDimens.fCaption,
        fontWeight: FontWeight.w800,
        letterSpacing: 0.8,
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// Heatmap widget — unchanged logic, green shades only
// ═══════════════════════════════════════════════════════════════════════════════
class ContributionHeatMap extends StatelessWidget {
  const ContributionHeatMap(
      {Key? key,
      required this.values,
      required this.primary,
      this.isBinary = false})
      : super(key: key);

  final List<int> values;
  final Color primary;
  final bool isBinary;

  // Green shades — used by the legend too.
  static const Color _empty = Color(0x00000000);
  static const Color l1 = Color(0xFF9BE9A8);
  static const Color l2 = Color(0xFF40C463);
  static const Color l3 = Color(0xFF30A14E);
  static const Color l4 = Color(0xFF216E39);
  static const Color l5 = Color(0xFF144620);
  static const kLevels = [_empty, l1, l2, l3, l4, l5];

  Color _colorFor(int v) {
    if (isBinary) return v <= 0 ? _empty : l3;
    if (v <= 0) return _empty;
    if (v == 1) return l1;
    if (v == 2) return l2;
    if (v == 3) return l3;
    if (v == 4) return l4;
    return l5;
  }

  @override
  Widget build(BuildContext context) {
    final days = values.length;
    final now = DateTime.now();
    final dateEnd = DateTime(now.year, now.month, now.day);
    final daysSinceMonday = dateEnd.weekday - DateTime.monday;
    final alignedEnd = dateEnd.subtract(Duration(days: daysSinceMonday));
    final alignedStart = alignedEnd.subtract(Duration(days: days - 1));
    final weeks = (days / 7).ceil();

    final padded = List<int>.from(values);
    while (padded.length < weeks * 7) {
      padded.insert(0, 0);
    }

    const colGap = 5.0;
    const rowGap = 5.0;
    const cell = 14.0;

    String monthLabel(DateTime d) {
      const months = [
        'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
        'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
      ];
      return months[d.month - 1];
    }

    Map<int, String> monthLabelsByWeek() {
      final labels = <int, String>{};
      for (int w = 0; w < weeks; w++) {
        final weekStart = alignedStart.add(Duration(days: w * 7));
        for (int r = 0; r < 7; r++) {
          final d = weekStart.add(Duration(days: r));
          if (d.day == 1) {
            labels[w] = monthLabel(d);
            break;
          }
        }
      }
      labels.putIfAbsent(0, () => monthLabel(alignedStart));
      return labels;
    }

    final monthByWeek = monthLabelsByWeek();
    const dayLabels = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];

    return LayoutBuilder(builder: (context, constraints) {
      final neededWidth = weeks * cell + (weeks - 1) * colGap;

      Widget grid() {
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: List.generate(weeks, (w) {
            final label = monthByWeek[w] ?? '';
            return Padding(
              padding: EdgeInsets.only(
                  right: w == weeks - 1 ? 0 : colGap),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 14,
                    child: Text(label,
                        style: const TextStyle(
                            fontSize: 9,
                            color: _muted,
                            fontWeight: FontWeight.w700)),
                  ),
                  const SizedBox(height: 4),
                  Column(
                    children: List.generate(7, (r) {
                      final idx = w * 7 + r;
                      final v = padded[idx];
                      final c = _colorFor(v);
                      final emptyFill =
                          _green.withValues(alpha: 0.07);
                      return Padding(
                        padding: EdgeInsets.only(
                            bottom: r == 6 ? 0 : rowGap),
                        child: Container(
                          width: cell,
                          height: cell,
                          decoration: BoxDecoration(
                            color: v <= 0 ? emptyFill : c,
                            borderRadius: const BorderRadius.all(
                                Radius.circular(2)),
                          ),
                        ),
                      );
                    }),
                  ),
                ],
              ),
            );
          }),
        );
      }

      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 16,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: List.generate(7, (r) {
                return Padding(
                  padding:
                      EdgeInsets.only(bottom: r == 6 ? 0 : rowGap),
                  child: SizedBox(
                    height: cell,
                    child: Text(dayLabels[r],
                        style: const TextStyle(
                            fontSize: 9,
                            color: _muted,
                            fontWeight: FontWeight.w600)),
                  ),
                );
              }),
            ),
          ),
          const SizedBox(width: 6),
          Expanded(
            child: neededWidth <= constraints.maxWidth
                ? grid()
                : SingleChildScrollView(
                    scrollDirection: Axis.horizontal, child: grid()),
          ),
        ],
      );
    });
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// Rating graph — unchanged, always rendered in green
// ═══════════════════════════════════════════════════════════════════════════════
class RatingGraph extends StatelessWidget {
  const RatingGraph(
      {super.key,
      required this.values,
      required this.lineColor,
      required this.currentValue});

  final List<int> values;
  final Color lineColor;
  final int currentValue;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _RatingPainter(
          values: values,
          lineColor: lineColor,
          currentValue: currentValue),
      size: const Size(double.infinity, double.infinity),
    );
  }
}

class _RatingPainter extends CustomPainter {
  _RatingPainter(
      {required this.values,
      required this.lineColor,
      required this.currentValue});

  final List<int> values;
  final Color lineColor;
  final int currentValue;

  @override
  void paint(Canvas canvas, Size size) {
    if (values.isEmpty) return;

    const padL = 38.0, padR = 12.0, padT = 10.0, padB = 26.0;
    final w = size.width, h = size.height;

    final minV = values.reduce(min).toDouble();
    final maxV = values.reduce(max).toDouble();
    final minY = min(minV, currentValue.toDouble());
    final maxY = max(maxV, currentValue.toDouble());
    final range = (maxY - minY) == 0 ? 1.0 : (maxY - minY);

    Offset pt(int i) {
      final x = padL +
          (values.length == 1
              ? 0.0
              : (i / (values.length - 1)) * (w - padL - padR));
      final y =
          (h - padB) - ((values[i] - minY) / range) * (h - padT - padB);
      return Offset(x, y);
    }

    double yFor(double v) =>
        (h - padB) - ((v - minY) / range) * (h - padT - padB);

    final tp = TextPainter(textDirection: TextDirection.ltr);
    final labelSt = const TextStyle(
        color: _muted, fontSize: 9, fontWeight: FontWeight.w700);

    // Grid lines
    final gridPaint = Paint()
      ..color = _green.withValues(alpha: 0.10)
      ..strokeWidth = 1;
    for (int i = 0; i <= 4; i++) {
      final y = padT + (i / 4.0) * (h - padT - padB);
      canvas.drawLine(Offset(padL, y), Offset(w - padR, y), gridPaint);
      final v = (maxY - (i / 4.0) * (maxY - minY)).round();
      tp.text = TextSpan(style: labelSt, text: v.toString());
      tp.layout();
      tp.paint(canvas, Offset(padL - tp.width - 6, y - tp.height / 2));
    }

    // X labels
    final xCount = values.length;
    for (final i in [0, (xCount / 2).round(), xCount - 1]) {
      final p = pt(i);
      tp.text = TextSpan(style: labelSt, text: 'C${i + 1}');
      tp.layout();
      tp.paint(
          canvas, Offset(p.dx - tp.width / 2, h - padB + 6));
    }

    // Dashed current-rating line
    final yCur = yFor(currentValue.toDouble());
    _dashed(
        canvas,
        Offset(padL, yCur),
        Offset(w - padR, yCur),
        Paint()
          ..color = lineColor.withValues(alpha: 0.45)
          ..strokeWidth = 1.2);
    tp.text = TextSpan(
        style: TextStyle(
            color: lineColor,
            fontSize: 9,
            fontWeight: FontWeight.w900),
        text: 'Current $currentValue');
    tp.layout();
    tp.paint(canvas,
        Offset(w - padR - tp.width, yCur - tp.height - 3));

    // Build smooth path
    final pts = [for (int i = 0; i < values.length; i++) pt(i)];
    final path = _smooth(pts);

    // Fill
    final fillPaint = Paint()
      ..shader = LinearGradient(
        colors: [
          lineColor.withValues(alpha: 0.18),
          lineColor.withValues(alpha: 0.00)
        ],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ).createShader(Rect.fromLTWH(0, 0, w, h));
    final fillPath = Path.from(path)
      ..lineTo(pts.last.dx, h - padB)
      ..lineTo(pts.first.dx, h - padB)
      ..close();
    canvas.drawPath(fillPath, fillPaint);

    // Glow
    canvas.drawPath(
        path,
        Paint()
          ..color = lineColor.withValues(alpha: 0.25)
          ..strokeWidth = 8
          ..style = PaintingStyle.stroke
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8));

    // Line
    canvas.drawPath(
        path,
        Paint()
          ..color = lineColor
          ..strokeWidth = 2.5
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.round
          ..isAntiAlias = true);

    // Dots
    for (final p in pts) {
      canvas.drawCircle(p, 3.5, Paint()..color = Colors.white);
      canvas.drawCircle(
          p,
          3.5,
          Paint()
            ..color = lineColor
            ..style = PaintingStyle.stroke
            ..strokeWidth = 2);
    }
  }

  static void _dashed(Canvas c, Offset a, Offset b, Paint p,
      {double dw = 6, double dg = 4}) {
    final dx = b.dx - a.dx, dy = b.dy - a.dy;
    final dist = sqrt(dx * dx + dy * dy);
    if (dist == 0) return;
    final vx = dx / dist, vy = dy / dist;
    double t = 0;
    while (t < dist) {
      final to = min(t + dw, dist);
      c.drawLine(Offset(a.dx + vx * t, a.dy + vy * t),
          Offset(a.dx + vx * to, a.dy + vy * to), p);
      t += dw + dg;
    }
  }

  static Path _smooth(List<Offset> pts) {
    if (pts.length < 2) return Path()..addPolygon(pts, false);
    final p = Path()..moveTo(pts[0].dx, pts[0].dy);
    for (int i = 0; i < pts.length - 1; i++) {
      final p0 = i == 0 ? pts[i] : pts[i - 1];
      final p1 = pts[i];
      final p2 = pts[i + 1];
      final p3 = (i + 2 < pts.length) ? pts[i + 2] : p2;
      const t = 0.18;
      p.cubicTo(
        p1.dx + (p2.dx - p0.dx) * t, p1.dy + (p2.dy - p0.dy) * t,
        p2.dx - (p3.dx - p1.dx) * t, p2.dy - (p3.dy - p1.dy) * t,
        p2.dx, p2.dy,
      );
    }
    return p;
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
