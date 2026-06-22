import 'dart:math';
import 'package:flutter/material.dart';
import 'package:lab_portal/core/theme/app_dimens.dart';
import 'package:lab_portal/core/ui_constants.dart';
import 'package:lab_portal/future/main/domain/entity/user_entity.dart';
import 'package:lab_portal/future/main/presentation/page/profile_page.dart'
    show ContributionHeatMap, RatingGraph;

// ── Palette aliases (green + white only) ──────────────────────────────────────
const _green = UiConstants.primaryButtonColor;
const _surface = UiConstants.infoBackgroundColor;
const _white = UiConstants.mainTextColor;
const _muted = UiConstants.subtitleTextColor;

BoxDecoration get _card => BoxDecoration(
      color: _surface,
      borderRadius: AppDimens.brLg,
      border: Border.all(color: _green.withValues(alpha: 0.15)),
    );

/// Public profile of another user — same visual language as the Profile tab,
/// but pushed onto the stack (back button, no bottom nav) and read-only.
class UserDetailsPage extends StatelessWidget {
  final UserEntity user;
  const UserDetailsPage({super.key, required this.user});

  // Deterministic per-user mock activity so the page is stable between rebuilds
  // until real per-user history is wired from the backend.
  int get _seed => user.username.isEmpty ? user.rating : user.username.hashCode;

  List<int> _contributions(int days) {
    final rnd = Random(_seed);
    return List<int>.generate(days, (i) {
      final base = (sin(i / 7) * 3).round();
      final noise = rnd.nextInt(3);
      return max(0, base + noise + (i % 6 == 0 ? rnd.nextInt(3) : 0));
    });
  }

  List<int> _attendance(int days) {
    final rnd = Random(_seed ^ 0x9E3779B9);
    return List<int>.generate(days, (i) => rnd.nextInt(10) < 6 ? 1 : 0);
  }

  // A rising rating curve that lands on the user's current rating.
  List<int> _ratingHistory() {
    final rnd = Random(_seed);
    const n = 12;
    final out = <int>[];
    var v = (user.rating - 220 - rnd.nextInt(120)).clamp(800, user.rating);
    for (var i = 0; i < n - 1; i++) {
      v += rnd.nextInt(60) - 18;
      out.add(v.clamp(800, 4000));
    }
    out.add(user.rating);
    return out;
  }

  @override
  Widget build(BuildContext context) {
    const days = 168;
    final contributions = _contributions(days);
    final attendance = _attendance(days);
    final ratingHistory = _ratingHistory();

    return Scaffold(
      backgroundColor: UiConstants.backgroundColor,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(child: _Hero(user: user)),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                  AppDimens.lg, AppDimens.lg, AppDimens.lg, 0),
              child: _StatsGrid(user: user),
            ),
          ),
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
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                  AppDimens.lg, AppDimens.lg, AppDimens.lg, 0),
              child: _RatingCard(history: ratingHistory, current: user.rating),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                  AppDimens.lg, AppDimens.lg, AppDimens.lg, AppDimens.xl),
              child: _AchievementsCard(user: user),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Hero header ───────────────────────────────────────────────────────────────
class _Hero extends StatelessWidget {
  final UserEntity user;
  const _Hero({required this.user});

  String _initials() {
    final name = user.fullName.isEmpty ? user.username : user.fullName;
    if (name.isEmpty) return 'U';
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.length == 1) {
      return parts[0].substring(0, min(2, parts[0].length)).toUpperCase();
    }
    return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final hasImage = user.avatarUrl.isNotEmpty;
    return Container(
      padding: EdgeInsets.fromLTRB(AppDimens.lg,
          MediaQuery.of(context).padding.top + AppDimens.sm, AppDimens.lg, AppDimens.lg),
      decoration: BoxDecoration(
        // Muted deep-green → surface so the header matches the card tones
        // below rather than glowing brighter than the rest of the page.
        gradient: const LinearGradient(
          colors: [UiConstants.primaryDark, _surface],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(AppDimens.rLg),
          bottomRight: Radius.circular(AppDimens.rLg),
        ),
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
          // Back + share row
          Row(
            children: [
              _CircleBtn(
                icon: Icons.arrow_back_rounded,
                onTap: () => Navigator.of(context).maybePop(),
              ),
              const Spacer(),
              _CircleBtn(icon: Icons.ios_share_outlined, onTap: () {}),
            ],
          ),
          const SizedBox(height: AppDimens.md),
          // Avatar + name
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(3),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.25),
                ),
                child: CircleAvatar(
                  radius: 32,
                  backgroundColor: UiConstants.primaryDark,
                  foregroundImage:
                      hasImage ? NetworkImage(user.avatarUrl) : null,
                  onForegroundImageError: hasImage ? (_, __) {} : null,
                  child: Text(
                    _initials(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: AppDimens.fH1,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: AppDimens.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user.fullName.isEmpty ? user.username : user.fullName,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: AppDimens.fH1,
                        fontWeight: FontWeight.w900,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: AppDimens.xxs),
                    Text(
                      '@${user.username}',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: AppDimens.fBody,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (user.bio.isNotEmpty) ...[
            const SizedBox(height: AppDimens.md),
            Text(
              user.bio,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: AppDimens.fBody,
                height: 1.4,
              ),
            ),
          ],
          const SizedBox(height: AppDimens.md),
          Wrap(
            spacing: AppDimens.sm,
            runSpacing: AppDimens.sm,
            children: [
              _HeroPill(label: 'Rating', value: user.rating.toString()),
              _HeroPill(label: 'Rank', value: user.rank),
              _HeroPill(label: 'Division', value: user.division),
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
          Text('$label  ',
              style: const TextStyle(
                color: Colors.white60,
                fontSize: AppDimens.fCaption,
                fontWeight: FontWeight.w700,
              )),
          Text(value.isEmpty ? '—' : value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: AppDimens.fCaption,
                fontWeight: FontWeight.w900,
              )),
        ],
      ),
    );
  }
}

class _CircleBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _CircleBtn({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.18),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: Colors.white, size: AppDimens.iconMd),
      ),
    );
  }
}

// ── Stats 2×2 grid ────────────────────────────────────────────────────────────
class _StatsGrid extends StatelessWidget {
  final UserEntity user;
  const _StatsGrid({required this.user});

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
                    value: '${user.solvedProblems}')),
            const SizedBox(width: AppDimens.sm),
            Expanded(
                child: _StatTile(
                    icon: Icons.bolt_outlined,
                    label: 'Contributions',
                    value: '${user.contributions}')),
          ],
        ),
        const SizedBox(height: AppDimens.sm),
        Row(
          children: [
            Expanded(
                child: _StatTile(
                    icon: Icons.trending_up_rounded,
                    label: 'Rating',
                    value: '${user.rating}')),
            const SizedBox(width: AppDimens.sm),
            Expanded(
                child: _StatTile(
                    icon: Icons.leaderboard_outlined,
                    label: 'Division',
                    value: user.division.isEmpty ? '—' : user.division)),
          ],
        ),
      ],
    );
  }
}

class _StatTile extends StatelessWidget {
  final IconData icon;
  final String label, value;
  const _StatTile(
      {required this.icon, required this.label, required this.value});

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
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: _white,
                      fontSize: AppDimens.fH2,
                      fontWeight: FontWeight.w900,
                    )),
                Text(label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
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

// ── Activity / consistency card ───────────────────────────────────────────────
class _ActivityCard extends StatefulWidget {
  final List<int> contributions;
  final List<int> attendance;
  const _ActivityCard({required this.contributions, required this.attendance});

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
              const Expanded(child: _SectionLabel('CONSISTENCY')),
              Container(
                decoration: BoxDecoration(
                  color: _green.withValues(alpha: 0.10),
                  borderRadius: AppDimens.brSm,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _Tab(
                        label: 'Solves',
                        selected: _tab == 0,
                        onTap: () => setState(() => _tab = 0)),
                    _Tab(
                        label: 'Attendance',
                        selected: _tab == 1,
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
                        borderRadius:
                            const BorderRadius.all(Radius.circular(2)),
                        border:
                            Border.all(color: _green.withValues(alpha: 0.15)),
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
  const _Tab(
      {required this.label, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(
            horizontal: AppDimens.sm, vertical: AppDimens.xs),
        decoration: BoxDecoration(
          color: selected ? _green : Colors.transparent,
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

// ── Rating graph card ─────────────────────────────────────────────────────────
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
              Text('Last ${history.length} contests',
                  style: const TextStyle(
                      color: _muted, fontSize: AppDimens.fCaption)),
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

// ── Achievements ──────────────────────────────────────────────────────────────
class _AchievementsCard extends StatelessWidget {
  final UserEntity user;
  const _AchievementsCard({required this.user});

  @override
  Widget build(BuildContext context) {
    // Derive a few badges from the user's real numbers.
    final badges = <(IconData, String)>[
      if (user.solvedProblems >= 100)
        (Icons.star_border_rounded, '100+ Solves'),
      if (user.rating >= 1600) (Icons.emoji_events_outlined, 'Expert'),
      if (user.contributions >= 10) (Icons.volunteer_activism_outlined, 'Contributor'),
      (Icons.flag_outlined,
          user.division.isEmpty ? 'Member' : 'Division ${user.division}'),
      (Icons.bolt_outlined, 'Active Solver'),
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
                          horizontal: AppDimens.md, vertical: AppDimens.sm),
                      decoration: BoxDecoration(
                        color: _green.withValues(alpha: 0.10),
                        borderRadius: const BorderRadius.all(
                            Radius.circular(AppDimens.rPill)),
                        border:
                            Border.all(color: _green.withValues(alpha: 0.25)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(b.$1, size: AppDimens.iconSm, color: _green),
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

// ── Shared label ──────────────────────────────────────────────────────────────
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
