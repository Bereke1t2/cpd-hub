import 'package:flutter/material.dart';
import 'package:cpd_hub/core/theme/theme_ext.dart';
import 'package:cpd_hub/core/ui_constants.dart';
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
    final sc = context.sc;
    return BasePage(
      title: "Leaderboard",
      subtitle: contestTitle,
      showBackButton: true,
      body: Column(
        children: [
          _buildPredictionHeader(sc),
          SizedBox(height: 16 * sc),
          _buildProblemStatsHeatmap(sc),
          SizedBox(height: 24 * sc),
          Expanded(
            child: _buildLeaderboardTable(sc),
          ),
        ],
      ),
    );
  }

  Widget _buildPredictionHeader(double sc) {
    return Hero(
      tag: 'contest_$contestTitle',
      child: Container(
        padding: EdgeInsets.all(20 * sc),
        margin: EdgeInsets.symmetric(horizontal: 16 * sc),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [UiConstants.primaryButtonColor.withValues(alpha: 0.2), Colors.blue.withValues(alpha: 0.1)],
          ),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: UiConstants.primaryButtonColor.withValues(alpha: 0.3)),
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
                    Text("Your Performance", style: TextStyle(color: UiConstants.subtitleTextColor, fontSize: 12 * sc)),
                    SizedBox(height: 4 * sc),
                    Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      spacing: 12 * sc,
                      runSpacing: 4 * sc,
                      children: [
                        Text("Rank #42", style: TextStyle(color: Colors.white, fontSize: 20 * sc, fontWeight: FontWeight.bold)),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 8 * sc, vertical: 2 * sc),
                          decoration: BoxDecoration(color: Colors.green.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(8)),
                          child: Text("+45 Rating", style: TextStyle(color: Colors.green, fontSize: 12 * sc, fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Icon(Icons.auto_graph_rounded, color: UiConstants.primaryButtonColor, size: 32 * sc),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProblemStatsHeatmap(double sc) {
    final problems = ['A', 'B', 'C', 'D', 'E', 'F', 'G'];
    final solveRates = [0.95, 0.82, 0.45, 0.12, 0.03, 0.01, 0.005];

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16 * sc),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Live Analytics", style: TextStyle(color: UiConstants.mainTextColor, fontSize: 13 * sc, fontWeight: FontWeight.bold, letterSpacing: 0.5)),
          SizedBox(height: 12 * sc),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            child: Row(
              children: List.generate(problems.length, (index) {
                return Container(
                  width: 65 * sc,
                  margin: EdgeInsets.only(right: 8 * sc),
                  padding: EdgeInsets.symmetric(vertical: 12 * sc),
                  decoration: BoxDecoration(
                    color: UiConstants.infoBackgroundColor,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: UiConstants.borderColor.withValues(alpha: 0.3)),
                  ),
                  child: Column(
                    children: [
                      Text(problems[index], style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12 * sc)),
                      SizedBox(height: 8 * sc),
                      Stack(
                        alignment: Alignment.bottomCenter,
                        children: [
                          Container(height: 40 * sc, width: 4 * sc, decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.05), borderRadius: BorderRadius.circular(2))),
                          Container(
                            height: 40 * sc * solveRates[index],
                            width: 4 * sc,
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
                                  color: (solveRates[index] > 0.5 ? Colors.green : Colors.orange).withValues(alpha: 0.3),
                                  blurRadius: 4,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 4 * sc),
                      Text("${(solveRates[index] * 100).toInt()}%", style: TextStyle(color: UiConstants.subtitleTextColor.withValues(alpha: 0.6), fontSize: 9 * sc, fontWeight: FontWeight.bold)),
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

  Widget _buildLeaderboardTable(double sc) {
    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 16 * sc),
      itemCount: leaderboard.length,
      itemBuilder: (context, index) {
        final entry = leaderboard[index];
        final ratingColor = UiConstants.getUserRatingColor(entry['rating']);

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
                offset: Offset(0, 4),
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
                    _buildRankBadge(entry['rank'], sc),
                    SizedBox(width: 12 * sc),
                    _buildUserAvatar(entry['username'], ratingColor, sc),
                    SizedBox(width: 12 * sc),
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
                              fontSize: 16 * sc,
                              letterSpacing: -0.5,
                            ),
                          ),
                          SizedBox(height: 6 * sc),
                          Wrap(
                            spacing: 3 * sc,
                            runSpacing: 3 * sc,
                            children: ['A', 'B', 'C', 'D', 'E'].map((p) {
                              final solved = (entry['problems'] as List).contains(p);
                              return Container(
                                width: 18 * sc,
                                height: 18 * sc,
                                decoration: BoxDecoration(
                                  color: solved ? Colors.green.withValues(alpha: 0.1) : Colors.white.withValues(alpha: 0.03),
                                  borderRadius: BorderRadius.circular(4),
                                  border: Border.all(
                                    color: solved ? Colors.green.withValues(alpha: 0.3) : Colors.transparent,
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    p,
                                    style: TextStyle(
                                      color: solved ? Colors.green : Colors.white24,
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
                    _buildPerformanceColumn(entry['score'], entry['penalty'], sc),
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
            "#$rank",
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
          username[0].toUpperCase(),
          style: TextStyle(color: ratingColor, fontWeight: FontWeight.bold, fontSize: 14 * sc),
        ),
      ),
    );
  }

  Widget _buildPerformanceColumn(num score, int penalty, double sc) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        _buildMiniMetric(Icons.star_rounded, score.toString(), Colors.blue, sc),
        SizedBox(height: 4 * sc),
        _buildMiniMetric(Icons.timer_rounded, "${penalty}m", Colors.orange, sc),
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

  Widget _buildMetricBadge(IconData icon, String value, String label, Color color, double sc) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10 * sc, vertical: 8 * sc),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 12 * sc, color: color),
              SizedBox(width: 4 * sc),
              Text(
                value,
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.w900,
                  fontSize: 13 * sc,
                ),
              ),
            ],
          ),
          SizedBox(height: 2 * sc),
          Text(
            label,
            style: TextStyle(
              color: color.withValues(alpha: 0.6),
              fontSize: 8 * sc,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }
}
