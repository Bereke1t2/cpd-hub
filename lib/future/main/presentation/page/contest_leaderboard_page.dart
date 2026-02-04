import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lab_portal/core/ui_constants.dart';
import 'package:lab_portal/future/main/domain/entitiy/contest_entitiy.dart';
import 'package:lab_portal/future/main/presentation/bloc/contest_leaderboard/contest_leaderboard_bloc.dart';
import 'package:lab_portal/future/main/presentation/di/main_di.dart';

import 'base_page.dart';

class ContestLeaderboardPage extends StatelessWidget {
  final ContestEntitiy contest;
  const ContestLeaderboardPage({super.key, required this.contest});

  Color _rankColor(int rank) {
    if (rank == 1) return const Color(0xFFFFD54F);
    if (rank == 2) return const Color(0xFFB0BEC5);
    if (rank == 3) return const Color(0xFFBCAAA4);
    return UiConstants.primaryButtonColor;
  }

  Color _ratingColor(int rating) {
    if (rating >= 1900) return const Color(0xFFFF8F00);
    if (rating >= 1600) return const Color(0xFF7E57C2);
    if (rating >= 1400) return const Color(0xFF1E88E5);
    if (rating >= 1200) return const Color(0xFF43A047);
    return const Color(0xFF9E9E9E);
  }

  // Small reusable pill
  Widget _statPill(String label, String value, {Color? valueColor}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(
              color: UiConstants.subtitleTextColor,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            )),
        const SizedBox(height: 2),
        Text(value,
            style: TextStyle(
              color: valueColor ?? UiConstants.mainTextColor,
              fontSize: 13,
              fontWeight: FontWeight.w800,
            )),
      ],
    );
  }

  Widget _wideTableHeader({
    required double rankW,
    required double solvedW,
    required double penaltyW,
    required double ratingW,
    required double gap,
    required double nameW,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: UiConstants.infoBackgroundColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: UiConstants.primaryButtonColor.withOpacity(0.14)),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Row(
        children: [
          SizedBox(
            width: rankW,
            child: Align(
              alignment: Alignment.centerRight,
              child: Text('#',
                  style: const TextStyle(
                      color: UiConstants.subtitleTextColor, fontSize: 12, fontWeight: FontWeight.w800)),
            ),
          ),
          SizedBox(width: gap),
          SizedBox(
            width: nameW,
            child: Text('Name',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                    color: UiConstants.subtitleTextColor, fontSize: 12, fontWeight: FontWeight.w800)),
          ),
          SizedBox(width: gap),
          SizedBox(
            width: solvedW,
            child: Align(
              alignment: Alignment.centerRight,
              child: Text('Solved',
                  style: const TextStyle(
                      color: UiConstants.subtitleTextColor, fontSize: 12, fontWeight: FontWeight.w800)),
            ),
          ),
          SizedBox(width: gap),
          SizedBox(
            width: penaltyW,
            child: Align(
              alignment: Alignment.centerRight,
              child: Text('Penalty',
                  style: const TextStyle(
                      color: UiConstants.subtitleTextColor, fontSize: 12, fontWeight: FontWeight.w800)),
            ),
          ),
          SizedBox(width: gap),
          SizedBox(
            width: ratingW,
            child: Align(
              alignment: Alignment.centerRight,
              child: Text('Δ Rating',
                  style: const TextStyle(
                      color: UiConstants.subtitleTextColor, fontSize: 12, fontWeight: FontWeight.w800)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _wideTableRow({
    required int index,
    required dynamic e,
    required double rankW,
    required double solvedW,
    required double penaltyW,
    required double ratingW,
    required double gap,
    required double nameW,
  }) {
    final isTop3 = e.position <= 3;
    final accent = _rankColor(e.position);
    final delta = e.newRating - e.oldRating;
    final deltaColor = (delta >= 0) ? const Color(0xFF2E7D32) : const Color(0xFFC62828);
    final borderColor = isTop3 ? accent.withOpacity(0.55) : UiConstants.primaryButtonColor.withOpacity(0.12);

    // avatar initials
    final initials = (e.username ?? '').isNotEmpty
        ? e.username.split(' ').map((s) => s.isNotEmpty ? s[0] : '').take(2).join().toUpperCase()
        : '?';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: UiConstants.infoBackgroundColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: borderColor),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Row(
        children: [
          SizedBox(
            width: rankW,
            child: Align(
              alignment: Alignment.centerRight,
              child: Text(
                e.position.toString(),
                style: TextStyle(
                  color: isTop3 ? UiConstants.mainTextColor : UiConstants.primaryButtonColor,
                  fontWeight: FontWeight.w900,
                  fontSize: 14,
                ),
              ),
            ),
          ),
          SizedBox(width: gap),
          SizedBox(
            width: nameW,
            child: Row(
              children: [
                CircleAvatar(
                  radius: 18,
                  backgroundColor: _ratingColor(e.newRating).withOpacity(0.12),
                  child: Text(
                    initials,
                    style: TextStyle(color: _ratingColor(e.newRating), fontWeight: FontWeight.w900),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        e.username,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(color: _ratingColor(e.newRating), fontWeight: FontWeight.w900, fontSize: 14),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${e.oldRating} -> ${e.newRating}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(color: UiConstants.subtitleTextColor, fontSize: 11, fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: gap),
          SizedBox(
            width: solvedW,
            child: Align(
              alignment: Alignment.centerRight,
              child: Text(e.solved.toString(), style: const TextStyle(fontWeight: FontWeight.w900)),
            ),
          ),
          SizedBox(width: gap),
          SizedBox(
            width: penaltyW,
            child: Align(
              alignment: Alignment.centerRight,
              child: Text(e.penalty.toString(), style: const TextStyle(color: UiConstants.subtitleTextColor, fontWeight: FontWeight.w800)),
            ),
          ),
          SizedBox(width: gap),
          SizedBox(
            width: ratingW,
            child: Align(
              alignment: Alignment.centerRight,
              child: Text('${delta >= 0 ? '+' : ''}$delta', style: TextStyle(color: deltaColor, fontWeight: FontWeight.w900)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _compactCardRow({required dynamic e}) {
    final accent = _rankColor(e.position);
    final delta = e.newRating - e.oldRating;
    final deltaColor = (delta >= 0) ? const Color(0xFF2E7D32) : const Color(0xFFC62828);

    final initials = (e.username ?? '').isNotEmpty
        ? e.username.split(' ').map((s) => s.isNotEmpty ? s[0] : '').take(2).join().toUpperCase()
        : '?';

    return Card(
      color: UiConstants.infoBackgroundColor,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: BorderSide(color: UiConstants.primaryButtonColor.withOpacity(0.08))),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: accent.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: accent.withOpacity(0.22)),
                  ),
                  child: Center(
                    child: Text(
                      e.position.toString(),
                      style: TextStyle(color: accent, fontWeight: FontWeight.w900, fontSize: 16),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 20,
                        backgroundColor: _ratingColor(e.newRating).withOpacity(0.12),
                        child: Text(initials, style: TextStyle(color: _ratingColor(e.newRating), fontWeight: FontWeight.w900)),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Text(e.username, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.w900)),
                          const SizedBox(height: 2),
                          Text('${e.oldRating} -> ${e.newRating}', style: const TextStyle(color: UiConstants.subtitleTextColor, fontSize: 12)),
                        ]),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                  Text('${delta >= 0 ? '+' : ''}$delta', style: TextStyle(color: deltaColor, fontWeight: FontWeight.w900)),
                  const SizedBox(height: 4),
                  Text('${e.solved} solved', style: const TextStyle(color: UiConstants.subtitleTextColor, fontSize: 12)),
                ]),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                _statPill('Problems', contest.numberOfProblems.toString()),
                const Spacer(),
                _statPill('Penalty', e.penalty.toString(), valueColor: UiConstants.subtitleTextColor),
              ],
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => MainDI.buildContestLeaderboardBloc()..add(ContestLeaderboardStarted(contest.contestUrl)),
      child: BasePage(
        title: 'Leaderboard',
        subtitle: contest.title,
        selectedIndex: 2,
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 6),
              child: Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: UiConstants.infoBackgroundColor,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: UiConstants.primaryButtonColor.withOpacity(0.16)),
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.10), blurRadius: 12, offset: const Offset(0, 4))],
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: UiConstants.primaryButtonColor.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Icon(Icons.emoji_events_outlined, color: UiConstants.primaryButtonColor),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text(
                          contest.platform,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(color: UiConstants.subtitleTextColor, fontWeight: FontWeight.w600, fontSize: 12),
                        ),
                        const SizedBox(height: 2),
                        Text(contest.title, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(color: UiConstants.mainTextColor, fontWeight: FontWeight.w800, fontSize: 16)),
                      ]),
                    ),
                    const SizedBox(width: 10),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                      decoration: BoxDecoration(
                        color: UiConstants.primaryButtonColor.withOpacity(0.10),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: UiConstants.primaryButtonColor.withOpacity(0.22)),
                      ),
                      child: Column(children: [
                        const Text('Problems', style: TextStyle(color: UiConstants.subtitleTextColor, fontSize: 11, fontWeight: FontWeight.w600)),
                        const SizedBox(height: 2),
                        Text(contest.numberOfProblems.toString(), style: const TextStyle(color: UiConstants.mainTextColor, fontWeight: FontWeight.w800)),
                      ]),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: BlocBuilder<ContestLeaderboardBloc, ContestLeaderboardState>(
                builder: (context, state) {
                  if (state is ContestLeaderboardLoading || state is ContestLeaderboardInitial) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (state is ContestLeaderboardError) {
                    return Center(child: Padding(padding: const EdgeInsets.all(16), child: Text(state.message)));
                  }

                  final entries = (state as ContestLeaderboardLoaded).entries;
                  if (entries.isEmpty) {
                    return const Center(
                      child: Padding(padding: EdgeInsets.all(16), child: Text('No users found for this contest leaderboard yet.', textAlign: TextAlign.center)),
                    );
                  }

                  return LayoutBuilder(builder: (context, constraints) {
                    final w = constraints.maxWidth;
                    final isCompact = w < 520;

                    if (isCompact) {
                      // compact / stacked layout: cards
                      return Padding(
                        padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                        child: ListView.separated(
                          itemCount: entries.length,
                          separatorBuilder: (_, __) => const SizedBox(height: 8),
                          itemBuilder: (context, index) {
                            final e = entries[index];
                            return _compactCardRow(e: e);
                          },
                        ),
                      );
                    }

                    // wide layout: table-like responsive row items
                    final gap = 12.0;
                    final rankW = math.max(48.0, w * 0.06);
                    final solvedW = math.max(56.0, w * 0.08);
                    final penaltyW = math.max(72.0, w * 0.10);
                    final ratingW = math.max(96.0, w * 0.12);

                    // name column gets remaining width but keep reasonable bounds
                    final nameW = (w - (rankW + solvedW + penaltyW + ratingW + gap * 4)).clamp(180.0, 520.0);

                    final minTableWidth = rankW + nameW + solvedW + penaltyW + ratingW + gap * 4;

                    return Padding(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                      child: Column(
                        children: [
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: ConstrainedBox(
                              constraints: BoxConstraints(minWidth: minTableWidth),
                              child: _wideTableHeader(
                                rankW: rankW,
                                solvedW: solvedW,
                                penaltyW: penaltyW,
                                ratingW: ratingW,
                                gap: gap,
                                nameW: nameW,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Expanded(
                            child: ListView.separated(
                              padding: EdgeInsets.zero,
                              itemCount: entries.length,
                              separatorBuilder: (_, __) => const SizedBox(height: 8),
                              itemBuilder: (context, index) {
                                final e = entries[index];
                                return SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: ConstrainedBox(
                                    constraints: BoxConstraints(minWidth: minTableWidth),
                                    child: _wideTableRow(
                                      index: index,
                                      e: e,
                                      rankW: rankW,
                                      solvedW: solvedW,
                                      penaltyW: penaltyW,
                                      ratingW: ratingW,
                                      gap: gap,
                                      nameW: nameW,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    );
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}