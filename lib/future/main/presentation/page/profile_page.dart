import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lab_portal/core/di/injection.dart';
import 'package:lab_portal/features/consistency/presentation/cubit/streak/streak_cubit.dart';
import 'package:lab_portal/future/main/presentation/bloc/profile/profile_bloc.dart';
import 'package:lab_portal/future/main/presentation/page/base_page.dart';
import '../../../../core/ui_constants.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  // Palette: keep primary as accent, everything else neutral.
  Color get _primary => UiConstants.primaryButtonColor;
  static const _surface = UiConstants.infoBackgroundColor;
  static const _text = UiConstants.mainTextColor;
  static const _muted = UiConstants.subtitleTextColor;

  static const _cardBorder = Color(0x0D000000); // ~ black 0.05

  TextStyle get _h1 => const TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: _text);
  TextStyle get _h2 => const TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: _text);
  TextStyle get _caption => const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: _muted, height: 1.25);

  BoxDecoration _card({Color? tint}) {
    final t = tint ?? _primary;
    return BoxDecoration(
      color: _surface,
      borderRadius: BorderRadius.circular(18),
      border: Border.all(color: Colors.black.withOpacity(0.05)),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.06),
          blurRadius: 22,
          offset: const Offset(0, 12),
        ),
      ],
      gradient: LinearGradient(
        colors: [t.withOpacity(0.09), _surface],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
    );
  }

  BoxDecoration _metricCard({Color? tint}) {
    final t = tint ?? _primary;
    return BoxDecoration(
      // Was pure white; keep it aligned with the dashboard surface.
      color: _surface,
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: Colors.black.withOpacity(0.05)),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.06),
          blurRadius: 18,
          offset: const Offset(0, 10),
        ),
      ],
      gradient: LinearGradient(
        colors: [t.withOpacity(0.06), _surface],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
    );
  }

  List<int> _generateMockContributions(int days) {
    final rnd = Random(42);
    return List<int>.generate(days, (i) {
      final base = (sin(i / 7) * 3).round();
      final noise = rnd.nextInt(3);
      return max(0, base + noise + (i % 6 == 0 ? rnd.nextInt(3) : 0));
    });
  }

  List<int> _generateMockAttendance(int days) {
    final rnd = Random(7);
    return List<int>.generate(days, (i) {
      final weekend = (i % 7 == 5 || i % 7 == 6);
      final p = (weekend ? 0.62 : 0.78) + 0.08 * sin(i / 13);
      return rnd.nextDouble() < p ? 1 : 0;
    });
  }

  String _initials(String name) {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty || name.isEmpty) return '?';
    if (parts.length == 1) return parts[0].substring(0, min(2, parts[0].length)).toUpperCase();
    return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
  }

  Color _ratingColor(int rating) {
    if (rating >= 2400) return const Color(0xFFFF0000);
    if (rating >= 2000) return const Color(0xFFFF8F00);
    if (rating >= 1900) return const Color(0xFF7E57C2);
    if (rating >= 1600) return const Color(0xFF1E88E5);
    if (rating >= 1400) return const Color(0xFF00BCD4);
    if (rating >= 1200) return const Color(0xFF43A047);
    return const Color(0xFF9E9E9E);
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => getIt<ProfileBloc>()..add(const ProfileStarted()),
        ),
        BlocProvider.value(value: getIt<StreakCubit>()..load()),
      ],
      child: BlocBuilder<ProfileBloc, ProfileState>(
        builder: (context, state) => _buildBody(context, state),
      ),
    );
  }

  Widget _buildBody(BuildContext context, ProfileState state) {
    // Resolve user data: real from BLoC, or sensible defaults while loading.
    final int rating;
    final String rank;
    final String division;
    final String fullName;
    final String username;
    final String bio;

    if (state is ProfileLoaded) {
      rating   = state.user.rating;
      rank     = state.user.rank;
      division = state.user.division;
      fullName = state.user.fullName;
      username = state.user.username;
      bio      = state.user.bio;
    } else {
      rating   = 0;
      rank     = '—';
      division = '—';
      fullName = state is ProfileLoading ? 'Loading…' : 'Profile';
      username = '';
      bio      = '';
    }

    final ratingColor = _ratingColor(rating);

    final days = 168;
    final contributions = _generateMockContributions(days);
    // Use real active days from StreakCubit; fall back to mock while loading.
    final streakState = context.watch<StreakCubit>().state;
    final activeDays = streakState is StreakLoaded
        ? streakState.streak.activeDays
        : <DateTime>[];
    final today = DateTime.now();
    final attendance = List<int>.generate(days, (i) {
      final d = DateTime(today.year, today.month, today.day - (days - 1 - i));
      return activeDays.any(
              (a) => a.year == d.year && a.month == d.month && a.day == d.day)
          ? 1
          : 0;
    });

    final ratingHistory = <int>[1180, 1210, 1260, 1290, 1330, 1380, 1410, 1470, 1490, 1510, 1500, rating];

    return BasePage(
      title: 'Profile',
      subtitle: 'Overview & activity',
      selectedIndex: 5,
      body: LayoutBuilder(builder: (context, constraints) {
        final isWide = constraints.maxWidth >= 980;
        return CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                child: _topHeader(rating: rating, ratingColor: ratingColor, rank: rank, division: division, fullName: fullName, username: username, bio: bio),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Center(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: isWide ? 1120 : double.infinity),
                    child: isWide
                        ? Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                flex: 7,
                                child: _leftColumn(
                                  ratingColor: ratingColor,
                                  contributions: contributions,
                                  attendance: attendance,
                                  ratingHistory: ratingHistory,
                                  currentRating: rating,
                                ),
                              ),
                              const SizedBox(width: 18),
                              Expanded(
                                flex: 4,
                                child: _rightColumn(ratingColor: ratingColor),
                              ),
                            ],
                          )
                        : Column(
                            children: [
                              _leftColumn(
                                ratingColor: ratingColor,
                                contributions: contributions,
                                attendance: attendance,
                                ratingHistory: ratingHistory,
                                currentRating: rating,
                              ),
                              const SizedBox(height: 14),
                              _rightColumn(ratingColor: ratingColor),
                            ],
                          ),
                  ),
                ),
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _topHeader({required int rating, required Color ratingColor, required String rank, required String division, required String fullName, required String username, required String bio}) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: Colors.black.withOpacity(0.05)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 22,
            offset: const Offset(0, 14),
          )
        ],
        gradient: LinearGradient(
          colors: [
            ratingColor.withOpacity(0.10),
            _primary.withOpacity(0.08),
            _surface,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(3),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(colors: [ratingColor, ratingColor.withOpacity(0.25)]),
            ),
            child: CircleAvatar(
              radius: 42,
              backgroundColor: Colors.white.withOpacity(0.55),
              child: Text(_initials(fullName), style: TextStyle(color: ratingColor, fontSize: 20, fontWeight: FontWeight.w900)),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(fullName.isEmpty ? '—' : fullName, style: _h1),
                        const SizedBox(height: 2),
                        if (username.isNotEmpty) Text('@$username', style: _caption),
                      ],
                    ),
                  ),
                  _iconPill(
                    icon: Icons.ios_share_outlined,
                    tooltip: 'Share',
                    onPressed: () {},
                  )
                ],
              ),
              const SizedBox(height: 10),
              Text(
                bio.isNotEmpty ? bio : 'Build consistency. Solve smarter every day.',
                style: TextStyle(color: _muted, height: 1.25, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  _metricPill('Rating', rating.toString(), color: ratingColor),
                  _metricPill('Rank', rank, color: _primary),
                  _metricPill('Division', division, color: _primary),
                ],
              )
            ]),
          )
        ],
      ),
    );
  }

  Widget _iconPill({required IconData icon, required String tooltip, required VoidCallback onPressed}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.55),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.black.withOpacity(0.05)),
      ),
      child: IconButton(
        tooltip: tooltip,
        onPressed: onPressed,
        icon: Icon(icon, color: _muted.withOpacity(0.95)),
      ),
    );
  }

  Widget _leftColumn({
    required Color ratingColor,
    required List<int> contributions,
    required List<int> attendance,
    required List<int> ratingHistory,
    required int currentRating,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _HeatmapCard(
          title: 'Heatmap',
          subtitle: 'Last 6 months',
          decoration: _card(),
          contributions: contributions,
          attendance: attendance,
          subtleStyle: _caption,
          titleStyle: _h2,
          borderColor: _cardBorder,
        ),
        const SizedBox(height: 14),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: _card(tint: ratingColor),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              Text('Rating', style: _h2),
              const Spacer(),
              Text('Last ${ratingHistory.length} contests', style: _caption),
            ]),
            const SizedBox(height: 12),
            SizedBox(
              height: 190,
              child: RatingGraph(values: ratingHistory, lineColor: _primary, currentValue: currentRating),
            ),
            const SizedBox(height: 8),
            Text('Fintech-style trend with current rating marker.', style: _caption),
          ]),
        ),
        const SizedBox(height: 14),
        Container(
          padding: const EdgeInsets.all(14),
          decoration: _card(),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('Recent Contests', style: _h2),
            const SizedBox(height: 10),
            _contestCard('Weekly Challenge #24', '2 days ago', rankText: '#45', badgeColor: ratingColor),
            const SizedBox(height: 10),
            _contestCard('Sprint Round 12', '1 month ago', rankText: '#120', badgeColor: ratingColor),
            const SizedBox(height: 10),
            _contestCard('Monthly Marathon', '3 months ago', rankText: '#320', badgeColor: ratingColor),
          ]),
        ),
      ],
    );
  }

  Widget _rightColumn({required Color ratingColor}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          padding: const EdgeInsets.all(14),
          decoration: _card(),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            _sectionHeader('Performance'),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _metricTile(
                    title: 'Solved',
                    value: '320',
                    icon: Icons.check_circle_outline,
                    // Keep a strict minimal color system: use the app accent only.
                    // (Avoid a random green that reads as a separate brand color.)
                    accent: _primary,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _metricTile(
                    title: 'Streak',
                    value: '7d',
                    icon: Icons.local_fire_department_outlined,
                    accent: _primary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: _metricTile(
                    title: 'Contests',
                    value: '24',
                    icon: Icons.emoji_events_outlined,
                    accent: _primary,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _metricTile(
                    title: 'Rank',
                    value: '#1,204',
                    icon: Icons.leaderboard_outlined,
                    // Rating color is meaningful state (tier), so it can remain.
                    accent: ratingColor,
                  ),
                ),
              ],
            ),
          ]),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(14),
          decoration: _card(),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            _sectionHeader('Account'),
            const SizedBox(height: 12),
            _softListTile(
              icon: Icons.settings_outlined,
              title: 'Settings',
              subtitle: 'Notifications, appearance, privacy',
              onTap: () {},
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: _primary,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      side: BorderSide(color: _primary.withOpacity(0.30)),
                    ),
                    onPressed: () {},
                    icon: const Icon(Icons.edit_outlined),
                    label: const Text('Edit', style: TextStyle(fontWeight: FontWeight.w800)),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: _primary,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      side: BorderSide(color: _primary.withOpacity(0.22)),
                    ),
                    onPressed: () {},
                    icon: const Icon(Icons.logout),
                    label: const Text('Sign out', style: TextStyle(fontWeight: FontWeight.w800)),
                  ),
                ),
              ],
            ),
          ]),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(14),
          decoration: _card(),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            _sectionHeader('Achievements'),
            const SizedBox(height: 12),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                _badge('100 Solves', Icons.star_border),
                _badge('7-day Streak', Icons.local_fire_department),
                _badge('Top 10%', Icons.emoji_events),
                _badge('First Contest', Icons.flag_outlined),
              ],
            )
          ]),
        ),
      ],
    );
  }

  Widget _sectionHeader(String title) {
    return Row(children: [
      Expanded(child: Text(title, style: _h2)),
      Icon(Icons.circle, size: 6, color: _primary.withOpacity(0.35)),
      const SizedBox(width: 6),
      Icon(Icons.circle, size: 6, color: _primary.withOpacity(0.2)),
    ]);
  }

  Widget _metricPill(String label, String value, {required Color color}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.10),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: color.withOpacity(0.18)),
      ),
      child: RichText(
        text: TextSpan(
          style: const TextStyle(color: UiConstants.mainTextColor),
          children: [
            TextSpan(text: '$label  ', style: TextStyle(color: _muted, fontSize: 12, fontWeight: FontWeight.w700)),
            TextSpan(text: value, style: TextStyle(color: color, fontSize: 13, fontWeight: FontWeight.w900)),
          ],
        ),
      ),
    );
  }

  Widget _contestCard(String title, String when, {required String rankText, required Color badgeColor}) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.03),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.black.withOpacity(0.05)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: badgeColor.withOpacity(0.12),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: badgeColor.withOpacity(0.22)),
            ),
            child: Icon(Icons.emoji_events_outlined, color: badgeColor, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.w800, color: _text)),
                const SizedBox(height: 2),
                Text(when, style: _caption),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: badgeColor.withOpacity(0.10),
              borderRadius: BorderRadius.circular(999),
              border: Border.all(color: badgeColor.withOpacity(0.22)),
            ),
            child: Text(rankText, style: TextStyle(fontWeight: FontWeight.w900, color: badgeColor)),
          ),
        ],
      ),
    );
  }

  Widget _metricTile({required String title, required String value, required IconData icon, required Color accent}) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: _metricCard(tint: accent),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: accent.withOpacity(0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: accent, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(value, style: const TextStyle(fontWeight: FontWeight.w900, color: _text, fontSize: 18)),
                const SizedBox(height: 4),
                Text(title, style: _caption),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _softListTile({required IconData icon, required String title, required String subtitle, required VoidCallback onTap}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.04),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.black.withOpacity(0.05)),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
        leading: Icon(icon, color: _primary),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w800, color: _text)),
        subtitle: Text(subtitle, style: _caption),
        trailing: Icon(Icons.chevron_right, color: _muted.withOpacity(0.9)),
        onTap: onTap,
      ),
    );
  }

  Widget _badge(String label, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
      decoration: BoxDecoration(
        color: _primary.withOpacity(0.10),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: Colors.black.withOpacity(0.05)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: _primary),
          const SizedBox(width: 8),
          Text(label, style: const TextStyle(color: _text, fontWeight: FontWeight.w800)),
        ],
      ),
    );
  }
}

class _HeatmapCard extends StatefulWidget {
  const _HeatmapCard({
    required this.title,
    required this.subtitle,
    required this.decoration,
    required this.contributions,
    required this.attendance,
    required this.subtleStyle,
    required this.titleStyle,
    required this.borderColor,
  });

  final String title;
  final String subtitle;
  final BoxDecoration decoration;
  final List<int> contributions;
  final List<int> attendance;
  final TextStyle subtleStyle;
  final TextStyle titleStyle;
  final Color borderColor;

  @override
  State<_HeatmapCard> createState() => _HeatmapCardState();
}

class _HeatmapCardState extends State<_HeatmapCard> {
  int _selected = 0;

  @override
  Widget build(BuildContext context) {
    final values = _selected == 0 ? widget.contributions : widget.attendance;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: widget.decoration,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Text(widget.title, style: widget.titleStyle),
          const Spacer(),
          Text(widget.subtitle, style: widget.subtleStyle),
        ]),
        const SizedBox(height: 10),
        Align(
          alignment: Alignment.centerLeft,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.06),
              borderRadius: BorderRadius.circular(999),
              border: Border.all(color: widget.borderColor),
            ),
            child: Padding(
              padding: const EdgeInsets.all(4),
              child: SegmentedButton<int>(
                showSelectedIcon: false,
                style: ButtonStyle(
                  visualDensity: VisualDensity.compact,
                  padding: const MaterialStatePropertyAll(EdgeInsets.symmetric(horizontal: 12, vertical: 10)),
                  textStyle: const MaterialStatePropertyAll(TextStyle(fontWeight: FontWeight.w800, fontSize: 12)),
                  shape: MaterialStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(999))),
                  side: const MaterialStatePropertyAll(BorderSide(color: Colors.transparent)),
                  backgroundColor: MaterialStateProperty.resolveWith((states) {
                    if (states.contains(MaterialState.selected)) {
                      return UiConstants.primaryButtonColor.withOpacity(0.16);
                    }
                    return Colors.transparent;
                  }),
                  foregroundColor: MaterialStateProperty.resolveWith((states) {
                    if (states.contains(MaterialState.selected)) {
                      return UiConstants.primaryButtonColor;
                    }
                    return UiConstants.subtitleTextColor;
                  }),
                  overlayColor: MaterialStatePropertyAll(UiConstants.primaryButtonColor.withOpacity(0.10)),
                ),
                segments: const [
                  ButtonSegment(value: 0, label: Text('Contributions')),
                  ButtonSegment(value: 1, label: Text('Attendance')),
                ],
                selected: {_selected},
                onSelectionChanged: (s) => setState(() => _selected = s.first),
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 210,
          child: ContributionHeatMap(values: values, primary: UiConstants.primaryButtonColor, isBinary: _selected == 1),
        ),
        const SizedBox(height: 12),
        Row(children: [
          Text('Less', style: widget.subtleStyle),
          const SizedBox(width: 8),
          _legendDot(ContributionHeatMap.empty, widget.borderColor),
          const SizedBox(width: 6),
          _legendDot(ContributionHeatMap.l1, widget.borderColor),
          const SizedBox(width: 6),
          _legendDot(ContributionHeatMap.l2, widget.borderColor),
          const SizedBox(width: 6),
          _legendDot(ContributionHeatMap.l3, widget.borderColor),
          const SizedBox(width: 6),
          _legendDot(ContributionHeatMap.l4, widget.borderColor),
          const SizedBox(width: 6),
          _legendDot(ContributionHeatMap.l5, widget.borderColor),
          const SizedBox(width: 8),
          Text('More', style: widget.subtleStyle),
        ]),
      ]),
    );
  }

  Widget _legendDot(Color c, Color border) {
    return Container(
      width: 16,
      height: 12,
      decoration: BoxDecoration(
        color: c,
        borderRadius: BorderRadius.circular(3),
        border: Border.all(color: border),
      ),
    );
  }
}

class ContributionHeatMap extends StatelessWidget {
  const ContributionHeatMap({Key? key, required this.values, required this.primary, this.isBinary = false}) : super(key: key);
  final List<int> values;
  final Color primary;
  final bool isBinary;

  static const empty = Color(0x00000000);
  static const l1 = Color(0xFF9BE9A8);
  static const l2 = Color(0xFF40C463);
  static const l3 = Color(0xFF30A14E);
  static const l4 = Color(0xFF216E39);
  static const l5 = Color(0xFF144620);

  Color _colorFor(int v) {
    if (isBinary) return v <= 0 ? empty : l3;
    if (v <= 0) return empty;
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

    // Align to a full week grid starting on Monday.
    final dateEnd = DateTime(now.year, now.month, now.day);
    final weekday = dateEnd.weekday; // Mon=1..Sun=7
    final daysSinceMonday = weekday - DateTime.monday;
    final alignedEnd = dateEnd.subtract(Duration(days: daysSinceMonday));
    final alignedStart = alignedEnd.subtract(Duration(days: days - 1));

    final weeks = (days / 7).ceil();

    // Pad to full weeks (front)
    final padded = List<int>.from(values);
    while (padded.length < weeks * 7) {
      padded.insert(0, 0);
    }

    const colGap = 6.0;
    const rowGap = 6.0;
    const cell = 16.0;

    String monthLabel(DateTime d) {
      const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
      return months[d.month - 1];
    }

    // Determine the exact week-column index where each month starts.
    // We place month label only above the column that contains the 1st day.
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
    final dayLabels = const ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

    return LayoutBuilder(builder: (context, constraints) {
      final neededWidth = weeks * cell + (weeks - 1) * colGap;

      Widget grid() {
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: List.generate(weeks, (w) {
            final label = monthByWeek[w] ?? '';
            return Padding(
              padding: EdgeInsets.only(right: w == weeks - 1 ? 0 : colGap),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 16,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        label,
                        style: const TextStyle(fontSize: 10, color: UiConstants.subtitleTextColor, fontWeight: FontWeight.w700),
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Column(
                    children: List.generate(7, (r) {
                      final idx = w * 7 + r;
                      final v = padded[idx];
                      final c = _colorFor(v);

                      final emptyFill = Colors.black.withOpacity(0.06);
                      final emptyStroke = Colors.black.withOpacity(0.08);

                      return Padding(
                        padding: EdgeInsets.only(bottom: r == 6 ? 0 : rowGap),
                        child: Container(
                          width: cell,
                          height: cell,
                          decoration: BoxDecoration(
                            color: v <= 0 ? emptyFill : c,
                            borderRadius: BorderRadius.circular(3),
                            border: Border.all(color: v <= 0 ? emptyStroke : Colors.black.withOpacity(0.10)),
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
            width: 40,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: List.generate(7, (r) {
                return Padding(
                  padding: EdgeInsets.only(bottom: r == 6 ? 0 : rowGap),
                  child: SizedBox(
                    height: cell,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        dayLabels[r],
                        style: const TextStyle(fontSize: 10, color: UiConstants.subtitleTextColor, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: (neededWidth <= constraints.maxWidth) ? grid() : SingleChildScrollView(scrollDirection: Axis.horizontal, child: grid()),
          ),
        ],
      );
    });
  }
}

class RatingGraph extends StatelessWidget {
  const RatingGraph({super.key, required this.values, required this.lineColor, required this.currentValue});

  final List<int> values;
  final Color lineColor;
  final int currentValue;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _FintechChartPainter(values: values, lineColor: lineColor, currentValue: currentValue),
      size: const Size(double.infinity, double.infinity),
    );
  }
}

class _FintechChartPainter extends CustomPainter {
  _FintechChartPainter({required this.values, required this.lineColor, required this.currentValue});

  final List<int> values;
  final Color lineColor;
  final int currentValue;

  @override
  void paint(Canvas canvas, Size size) {
    if (values.isEmpty) return;

    // Slightly more padding for in-app readability.
    const padL = 40.0;
    const padR = 14.0;
    const padT = 12.0;
    const padB = 28.0;

    final w = size.width;
    final h = size.height;

    final minV = values.reduce(min).toDouble();
    final maxV = values.reduce(max).toDouble();

    // Give breathing room so the curve doesn't hug the edges.
    final minY = min(minV, currentValue.toDouble());
    final maxY = max(maxV, currentValue.toDouble());
    final range = (maxY - minY) == 0 ? 1.0 : (maxY - minY);

    Offset pt(int i) {
      final x = padL + (values.length == 1 ? 0.0 : (i / (values.length - 1)) * (w - padL - padR));
      final y = (h - padB) - ((values[i] - minY) / range) * (h - padT - padB);
      return Offset(x, y);
    }

    double yForValue(double v) {
      return (h - padB) - ((v - minY) / range) * (h - padT - padB);
    }

    final tp = TextPainter(textDirection: TextDirection.ltr);
    final labelStyle = TextStyle(color: UiConstants.subtitleTextColor, fontSize: 10, fontWeight: FontWeight.w800);

    // Grid (Y)
    final grid = Paint()
      ..color = Colors.black.withOpacity(0.06)
      ..strokeWidth = 1;

    for (int i = 0; i <= 4; i++) {
      final y = padT + (i / 4.0) * (h - padT - padB);
      canvas.drawLine(Offset(padL, y), Offset(w - padR, y), grid);

      final v = (maxY - (i / 4.0) * (maxY - minY)).round();
      tp.text = TextSpan(style: labelStyle, text: v.toString());
      tp.layout();
      tp.paint(canvas, Offset(padL - tp.width - 8, y - tp.height / 2));
    }

    // X labels (sparse)
    final xCount = values.length;
    for (int i in [0, (xCount / 2).round(), xCount - 1]) {
      final p = pt(i);
      tp.text = TextSpan(style: labelStyle.copyWith(fontWeight: FontWeight.w700), text: 'C${i + 1}');
      tp.layout();
      tp.paint(canvas, Offset(p.dx - tp.width / 2, h - padB + 8));
    }

    // Dashed "current rating" line
    final yCur = yForValue(currentValue.toDouble());
    final dash = Paint()
      ..color = lineColor.withOpacity(0.55)
      ..strokeWidth = 1.2;

    _drawDashedLine(canvas, Offset(padL, yCur), Offset(w - padR, yCur), dash, dashWidth: 6, dashGap: 5);

    // Label for current rating
    tp.text = TextSpan(style: TextStyle(color: lineColor, fontSize: 10, fontWeight: FontWeight.w900), text: 'Current $currentValue');
    tp.layout();
    tp.paint(canvas, Offset(w - padR - tp.width, yCur - tp.height - 4));

    // Build cubic bezier smoothed path
    final points = [for (int i = 0; i < values.length; i++) pt(i)];
    final path = _cubicSmoothPath(points);

    // Fill under curve
    final fill = Paint()
      ..shader = LinearGradient(
        colors: [lineColor.withOpacity(0.16), lineColor.withOpacity(0.00)],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ).createShader(Rect.fromLTWH(0, 0, w, h));

    final fillPath = Path.from(path)
      ..lineTo(points.last.dx, h - padB)
      ..lineTo(points.first.dx, h - padB)
      ..close();

    canvas.drawPath(fillPath, fill);

    // Glow/Neon effect: draw blurred thick stroke behind line
    final glow = Paint()
      ..color = lineColor.withOpacity(0.30)
      ..strokeWidth = 9
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10);

    canvas.drawPath(path, glow);

    // Main line
    final line = Paint()
      ..color = lineColor
      ..strokeWidth = 2.8
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..isAntiAlias = true;

    canvas.drawPath(path, line);

    // Points
    final dotFill = Paint()..color = Colors.white;
    final dotStroke = Paint()
      ..color = lineColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    for (final p in points) {
      canvas.drawCircle(p, 3.8, dotFill);
      canvas.drawCircle(p, 3.8, dotStroke);
    }
  }

  static void _drawDashedLine(Canvas canvas, Offset a, Offset b, Paint paint, {double dashWidth = 5, double dashGap = 4}) {
    final dx = b.dx - a.dx;
    final dy = b.dy - a.dy;
    final dist = sqrt(dx * dx + dy * dy);
    if (dist == 0) return;

    final vx = dx / dist;
    final vy = dy / dist;

    double t = 0;
    while (t < dist) {
      final from = t;
      final to = min(t + dashWidth, dist);
      canvas.drawLine(Offset(a.dx + vx * from, a.dy + vy * from), Offset(a.dx + vx * to, a.dy + vy * to), paint);
      t += dashWidth + dashGap;
    }
  }

  static Path _cubicSmoothPath(List<Offset> pts) {
    if (pts.length < 2) {
      return Path()..addPolygon(pts, false);
    }

    final p = Path()..moveTo(pts[0].dx, pts[0].dy);

    for (int i = 0; i < pts.length - 1; i++) {
      final p0 = i == 0 ? pts[i] : pts[i - 1];
      final p1 = pts[i];
      final p2 = pts[i + 1];
      final p3 = (i + 2 < pts.length) ? pts[i + 2] : p2;

      // Catmull-Rom to Bezier conversion
      const tension = 0.18;
      final c1 = Offset(
        p1.dx + (p2.dx - p0.dx) * tension,
        p1.dy + (p2.dy - p0.dy) * tension,
      );
      final c2 = Offset(
        p2.dx - (p3.dx - p1.dx) * tension,
        p2.dy - (p3.dy - p1.dy) * tension,
      );

      p.cubicTo(c1.dx, c1.dy, c2.dx, c2.dy, p2.dx, p2.dy);
    }

    return p;
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
