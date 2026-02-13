import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cpd_hub/core/ui_constants.dart';
import 'package:cpd_hub/future/main/presentation/bloc/leaderboard_cubit.dart';
import 'package:cpd_hub/future/main/presentation/page/base_page.dart';

class ContestLeaderboardPage extends StatelessWidget {
  final String contestId;
  final String contestTitle;
  
  ContestLeaderboardPage({super.key, required this.contestId, required this.contestTitle});

  final List<Map<String, dynamic>> leaderboard = [
    {
      'rank': 1,
      'username': 'tourist',
      'rating': 3800,
      'solved': 5,
      'score': 4850,
      'penalty': 42,
      'problems': ['A', 'B', 'C', 'D', 'E'],
    },
    {
      'rank': 2,
      'username': 'benq',
      'rating': 3600,
      'solved': 5,
      'score': 4720,
      'penalty': 58,
      'problems': ['A', 'B', 'C', 'D', 'E'],
    },
    {
      'rank': 3,
      'username': 'radewoosh',
      'rating': 3500,
      'solved': 4,
      'score': 3900,
      'penalty': 110,
      'problems': ['A', 'B', 'C', 'D'],
    },
    {
      'rank': 4,
      'username': 'smartguy',
      'rating': 2900,
      'solved': 4,
      'score': 3850,
      'penalty': 125,
      'problems': ['A', 'B', 'C', 'D'],
    },
    {
      'rank': 5,
      'username': 'codewizard',
      'rating': 2750,
      'solved': 3,
      'score': 2800,
      'penalty': 140,
      'problems': ['A', 'B', 'C'],
    },
  ];

  @override
  Widget build(BuildContext context) {
    return BasePage(
      title: "Leaderboard",
      subtitle: contestTitle,
      showBackButton: true,
      body: Column(
        children: [
          _buildPredictionHeader(),
          const SizedBox(height: 16),
          _buildProblemStatsHeatmap(),
          const SizedBox(height: 24),
          Expanded(
            child: _buildLeaderboardTable(),
          ),
        ],
      ),
    );
  }

  Widget _buildPredictionHeader() {
    return Hero(
      tag: 'contest_$contestTitle',
      child: Container(
        padding: const EdgeInsets.all(20),
        margin: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [UiConstants.primaryButtonColor.withOpacity(0.2), Colors.blue.withOpacity(0.1)],
          ),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: UiConstants.primaryButtonColor.withOpacity(0.3)),
        ),
        child: Material(
          color: Colors.transparent,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Your Performance", style: TextStyle(color: UiConstants.subtitleTextColor, fontSize: 12)),
                    const SizedBox(height: 4),
                    Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      spacing: 12,
                      runSpacing: 4,
                      children: [
                        const Text("Rank #42", style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(color: Colors.green.withOpacity(0.2), borderRadius: BorderRadius.circular(8)),
                          child: const Text("+45 Rating", style: TextStyle(color: Colors.green, fontSize: 12, fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const Icon(Icons.auto_graph_rounded, color: UiConstants.primaryButtonColor, size: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProblemStatsHeatmap() {
    final problems = ['A', 'B', 'C', 'D', 'E', 'F', 'G'];
    final solveRates = [0.95, 0.82, 0.45, 0.12, 0.03, 0.01, 0.005];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Live Analytics", style: TextStyle(color: UiConstants.mainTextColor, fontSize: 13, fontWeight: FontWeight.bold, letterSpacing: 0.5)),
          const SizedBox(height: 12),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            child: Row(
              children: List.generate(problems.length, (index) {
                return Container(
                  width: 65,
                  margin: EdgeInsets.only(right: 8),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: UiConstants.infoBackgroundColor,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: UiConstants.borderColor.withOpacity(0.3)),
                  ),
                  child: Column(
                    children: [
                      Text(problems[index], style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
                      const SizedBox(height: 8),
                      Stack(
                        alignment: Alignment.bottomCenter,
                        children: [
                          Container(height: 40, width: 4, decoration: BoxDecoration(color: Colors.white.withOpacity(0.05), borderRadius: BorderRadius.circular(2))),
                          Container(
                            height: 40 * solveRates[index],
                            width: 4,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: solveRates[index] > 0.5 
                                  ? [Colors.green, Colors.greenAccent] 
                                  : [Colors.orange, Colors.redAccent],
                                begin: Alignment.bottomCenter,
                                end: Alignment.topCenter,
                              ),
                              borderRadius: BorderRadius.circular(2),
                              boxShadow: [
                                BoxShadow(
                                  color: (solveRates[index] > 0.5 ? Colors.green : Colors.orange).withOpacity(0.3),
                                  blurRadius: 4,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text("${(solveRates[index] * 100).toInt()}%", style: TextStyle(color: UiConstants.subtitleTextColor.withOpacity(0.6), fontSize: 9, fontWeight: FontWeight.bold)),
                    ],
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLeaderboardTable() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: leaderboard.length,
      itemBuilder: (context, index) {
        final entry = leaderboard[index];
        final ratingColor = UiConstants.getUserRatingColor(entry['rating']);
        
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: UiConstants.infoBackgroundColor,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: UiConstants.borderColor.withOpacity(0.2)),
            boxShadow: [
              BoxShadow(
                color: ratingColor.withOpacity(0.05),
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
              splashColor: ratingColor.withOpacity(0.1),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                child: Row(
                  children: [
                    _buildRankBadge(entry['rank']),
                    const SizedBox(width: 12),
                    _buildUserAvatar(entry['username'], ratingColor),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            entry['username'],
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: ratingColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              letterSpacing: -0.5,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Wrap(
                            spacing: 3,
                            runSpacing: 3,
                            children: ['A', 'B', 'C', 'D', 'E'].map((p) {
                              final solved = (entry['problems'] as List).contains(p);
                              return Container(
                                width: 18,
                                height: 18,
                                decoration: BoxDecoration(
                                  color: solved ? Colors.green.withOpacity(0.1) : Colors.white.withOpacity(0.03),
                                  borderRadius: BorderRadius.circular(4),
                                  border: Border.all(
                                    color: solved ? Colors.green.withOpacity(0.3) : Colors.transparent,
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    p,
                                    style: TextStyle(
                                      color: solved ? Colors.green : Colors.white24,
                                      fontSize: 8,
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
                    const SizedBox(width: 8),
                    _buildPerformanceColumn(entry['score'], entry['penalty']),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildRankBadge(int rank) {
    Color badgeColor;
    IconData? rankIcon;
    bool isElite = rank <= 3;

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
      badgeColor = UiConstants.subtitleTextColor.withOpacity(0.6);
    }

    return Container(
      width: 32,
      height: 48,
      decoration: BoxDecoration(
        color: badgeColor.withOpacity(isElite ? 0.15 : 0.05),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (isElite) Icon(rankIcon, size: 14, color: badgeColor),
          Text(
            "#$rank",
            style: TextStyle(
              color: badgeColor,
              fontWeight: FontWeight.w900,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserAvatar(String username, Color ratingColor) {
    return Container(
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: ratingColor.withOpacity(0.5), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: ratingColor.withOpacity(0.2),
            blurRadius: 8,
            spreadRadius: 1,
          ),
        ],
      ),
      child: CircleAvatar(
        radius: 18,
        backgroundColor: UiConstants.infoBackgroundColor,
        child: Text(
          username[0].toUpperCase(),
          style: TextStyle(color: ratingColor, fontWeight: FontWeight.bold, fontSize: 14),
        ),
      ),
    );
  }

  Widget _buildPerformanceColumn(num score, int penalty) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        _buildMiniMetric(Icons.star_rounded, score.toString(), Colors.blue),
        const SizedBox(height: 4),
        _buildMiniMetric(Icons.timer_rounded, "${penalty}m", Colors.orange),
      ],
    );
  }

  Widget _buildMiniMetric(IconData icon, String value, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          value,
          style: TextStyle(
            color: color.withOpacity(0.9),
            fontWeight: FontWeight.w900,
            fontSize: 12,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(width: 4),
        Icon(icon, size: 12, color: color.withOpacity(0.7)),
      ],
    );
  }

  Widget _buildMetricBadge(IconData icon, String value, String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 12, color: color),
              const SizedBox(width: 4),
              Text(
                value,
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.w900,
                  fontSize: 13,
                ),
              ),
            ],
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(
              color: color.withOpacity(0.6),
              fontSize: 8,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }
}
