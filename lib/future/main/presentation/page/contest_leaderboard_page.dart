import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cpd_hub/core/theme/theme_ext.dart';
import 'package:cpd_hub/core/ui_constants.dart';
import 'package:cpd_hub/future/main/domain/entitiy/leaderboard_entry_entity.dart';
import 'package:cpd_hub/future/main/presentation/bloc/leaderboard_cubit.dart';
import 'package:cpd_hub/future/main/presentation/page/base_page.dart';

class ContestLeaderboardPage extends StatefulWidget {
  final String contestId;
  final String contestTitle;
  /// When false (upcoming contest), we do not call the API — avoids hanging requests.
  final bool isPast;

  const ContestLeaderboardPage({
    super.key,
    required this.contestId,
    required this.contestTitle,
    required this.isPast,
  });

  @override
  State<ContestLeaderboardPage> createState() => _ContestLeaderboardPageState();
}

class _ContestLeaderboardPageState extends State<ContestLeaderboardPage> {
  @override
  void initState() {
    super.initState();
    if (widget.isPast) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        context.read<LeaderboardCubit>().loadLeaderboard(widget.contestId);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final sc = context.sc;

    if (!widget.isPast) {
      return BasePage(
        title: 'Leaderboard',
        subtitle: widget.contestTitle,
        showBackButton: true,
        body: _buildUpcomingPlaceholder(sc),
      );
    }

    return BasePage(
      title: 'Leaderboard',
      subtitle: widget.contestTitle,
      showBackButton: true,
      body: BlocBuilder<LeaderboardCubit, LeaderboardState>(
        builder: (context, state) {
          if (state is LeaderboardLoading || state is LeaderboardInitial) {
            return const Center(child: CircularProgressIndicator(color: UiConstants.primaryButtonColor));
          }
          if (state is LeaderboardError) {
            return Padding(
              padding: EdgeInsets.all(24 * sc),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error_outline_rounded, color: Colors.redAccent, size: 48 * sc),
                    SizedBox(height: 16 * sc),
                    Text(
                      state.message,
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.redAccent, fontSize: 14 * sc),
                    ),
                    SizedBox(height: 24 * sc),
                    FilledButton.icon(
                      onPressed: () => context.read<LeaderboardCubit>().loadLeaderboard(widget.contestId),
                      icon: const Icon(Icons.refresh_rounded),
                      label: const Text('Retry'),
                      style: FilledButton.styleFrom(
                        backgroundColor: UiConstants.primaryButtonColor,
                        foregroundColor: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
          if (state is LeaderboardLoaded) {
            if (state.entries.isEmpty) {
              return Center(
                child: Text(
                  'No standings published yet.',
                  style: TextStyle(color: UiConstants.subtitleTextColor.withValues(alpha: 0.7), fontSize: 14 * sc),
                ),
              );
            }
            return _buildLeaderboardTable(state.entries, sc);
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildUpcomingPlaceholder(double sc) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 24 * sc, vertical: 32 * sc),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(24 * sc),
            decoration: BoxDecoration(
              color: UiConstants.infoBackgroundColor,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: UiConstants.borderColor.withValues(alpha: 0.2)),
            ),
            child: Column(
              children: [
                Icon(Icons.hourglass_empty_rounded, size: 56 * sc, color: UiConstants.primaryButtonColor.withValues(alpha: 0.8)),
                SizedBox(height: 20 * sc),
                Text(
                  'Contest not finished yet',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: UiConstants.mainTextColor,
                    fontSize: 18 * sc,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                SizedBox(height: 12 * sc),
                Text(
                  'Final standings and ratings will appear here after the contest ends. You can open this screen again once the contest is marked as past.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: UiConstants.subtitleTextColor.withValues(alpha: 0.85),
                    fontSize: 13 * sc,
                    height: 1.45,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLeaderboardTable(List<LeaderboardEntryEntity> entries, double sc) {
    return ListView.builder(
      padding: EdgeInsets.fromLTRB(16 * sc, 8 * sc, 16 * sc, 24 * sc),
      itemCount: entries.length,
      itemBuilder: (context, index) {
        final entry = entries[index];
        final ratingColor = UiConstants.getUserRatingColor(entry.rating);

        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: EdgeInsets.only(bottom: 12 * sc),
          decoration: BoxDecoration(
            color: UiConstants.infoBackgroundColor,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: UiConstants.borderColor.withValues(alpha: 0.2)),
            boxShadow: [
              BoxShadow(
                color: ratingColor.withValues(alpha: 0.05),
                blurRadius: 15,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {},
              borderRadius: BorderRadius.circular(24),
              splashColor: ratingColor.withValues(alpha: 0.1),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 12 * sc, vertical: 14 * sc),
                child: Row(
                  children: [
                    _buildRankBadge(entry.rank, sc),
                    SizedBox(width: 12 * sc),
                    _buildUserAvatar(entry.username, ratingColor, sc),
                    SizedBox(width: 12 * sc),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            entry.username,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: ratingColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 16 * sc,
                              letterSpacing: -0.5,
                            ),
                          ),
                          SizedBox(height: 4 * sc),
                          Text(
                            'Rating ${entry.rating} · ${entry.problemsSolved.length} solved',
                            style: TextStyle(
                              color: UiConstants.subtitleTextColor.withValues(alpha: 0.75),
                              fontSize: 11 * sc,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(height: 6 * sc),
                          if (entry.problemsSolved.isNotEmpty)
                            Wrap(
                              spacing: 3 * sc,
                              runSpacing: 3 * sc,
                              children: entry.problemsSolved.map((p) {
                                return Container(
                                  width: 18 * sc,
                                  height: 18 * sc,
                                  decoration: BoxDecoration(
                                    color: Colors.green.withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(4),
                                    border: Border.all(color: Colors.green.withValues(alpha: 0.3)),
                                  ),
                                  child: Center(
                                    child: Text(
                                      p,
                                      style: TextStyle(
                                        color: Colors.green,
                                        fontSize: 8 * sc,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                        ],
                      ),
                    ),
                    SizedBox(width: 8 * sc),
                    _buildPerformanceColumn(entry.score, entry.penalty, sc),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildRankBadge(int rank, double sc) {
    Color badgeColor;
    IconData? rankIcon;
    final isElite = rank <= 3;

    if (rank == 1) {
      badgeColor = Colors.amber;
      rankIcon = Icons.emoji_events_rounded;
    } else if (rank == 2) {
      badgeColor = Colors.grey[400]!;
      rankIcon = Icons.military_tech_rounded;
    } else if (rank == 3) {
      badgeColor = Colors.brown[300]!;
      rankIcon = Icons.military_tech_rounded;
    } else {
      badgeColor = UiConstants.subtitleTextColor.withValues(alpha: 0.6);
    }

    return Container(
      width: 32 * sc,
      height: 48 * sc,
      decoration: BoxDecoration(
        color: badgeColor.withValues(alpha: isElite ? 0.15 : 0.05),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (isElite) Icon(rankIcon, size: 14 * sc, color: badgeColor),
          Text(
            '#$rank',
            style: TextStyle(
              color: badgeColor,
              fontWeight: FontWeight.w900,
              fontSize: 10 * sc,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserAvatar(String username, Color ratingColor, double sc) {
    final initial = username.isNotEmpty ? username[0].toUpperCase() : '?';
    return Container(
      padding: EdgeInsets.all(2 * sc),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: ratingColor.withValues(alpha: 0.5), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: ratingColor.withValues(alpha: 0.2),
            blurRadius: 8,
            spreadRadius: 1,
          ),
        ],
      ),
      child: CircleAvatar(
        radius: 18 * sc,
        backgroundColor: UiConstants.infoBackgroundColor,
        child: Text(
          initial,
          style: TextStyle(color: ratingColor, fontWeight: FontWeight.bold, fontSize: 14 * sc),
        ),
      ),
    );
  }

  Widget _buildPerformanceColumn(int score, int penalty, double sc) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        _buildMiniMetric(Icons.star_rounded, score.toString(), Colors.blue, sc),
        SizedBox(height: 4 * sc),
        _buildMiniMetric(Icons.timer_rounded, '${penalty}m', Colors.orange, sc),
      ],
    );
  }

  Widget _buildMiniMetric(IconData icon, String value, Color color, double sc) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          value,
          style: TextStyle(
            color: color.withValues(alpha: 0.9),
            fontWeight: FontWeight.w900,
            fontSize: 12 * sc,
            letterSpacing: -0.5,
          ),
        ),
        SizedBox(width: 4 * sc),
        Icon(icon, size: 12 * sc, color: color.withValues(alpha: 0.7)),
      ],
    );
  }
}
