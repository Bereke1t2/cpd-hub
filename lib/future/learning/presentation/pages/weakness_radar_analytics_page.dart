import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:cpd_hub/core/theme/theme_ext.dart';
import 'package:cpd_hub/core/ui_constants.dart';
import 'package:cpd_hub/future/main/presentation/page/base_page.dart';
import 'package:cpd_hub/future/main/presentation/page/problem_details_page.dart';

/// Radar + “Solve this” card (mock scores until backend skill API exists).
class WeaknessRadarAnalyticsPage extends StatelessWidget {
  const WeaknessRadarAnalyticsPage({super.key});

  static const _tags = ['Math', 'Greedy', 'DP', 'Graphs', 'Data structures', 'Strings'];

  @override
  Widget build(BuildContext context) {
    final sc = context.sc;
    final values = [62.0, 78.0, 22.0, 48.0, 55.0, 70.0];

    return BasePage(
      showBackButton: true,
      selectedIndex: 0,
      title: 'Weakness radar',
      subtitle: 'Smart analytics (API later)',
      body: ListView(
        padding: EdgeInsets.fromLTRB(16 * sc, 8 * sc, 16 * sc, 100 * sc),
        children: [
          Text(
            'Skill strength from solved / failed tags (mock). Go: aggregate submissions by tag → normalize 0–100.',
            style: TextStyle(color: UiConstants.subtitleTextColor, fontSize: 11 * sc, height: 1.35),
          ),
          SizedBox(height: 16 * sc),
          SizedBox(
            height: 280 * sc,
            child: RadarChart(
              RadarChartData(
                radarShape: RadarShape.polygon,
                tickCount: 4,
                ticksTextStyle: TextStyle(color: UiConstants.subtitleTextColor.withValues(alpha: 0.5), fontSize: 9 * sc),
                tickBorderData: const BorderSide(color: Colors.white10),
                gridBorderData: const BorderSide(color: Colors.white10),
                radarBorderData: BorderSide(color: UiConstants.primaryButtonColor.withValues(alpha: 0.5), width: 1.5),
                titleTextStyle: TextStyle(color: UiConstants.mainTextColor, fontSize: 10 * sc, fontWeight: FontWeight.w600),
                getTitle: (index, angle) {
                  if (index >= 0 && index < _tags.length) {
                    return RadarChartTitle(text: _tags[index], angle: angle);
                  }
                  return const RadarChartTitle(text: '');
                },
                dataSets: [
                  RadarDataSet(
                    fillColor: UiConstants.primaryButtonColor.withValues(alpha: 0.22),
                    borderColor: UiConstants.primaryButtonColor,
                    borderWidth: 2.5,
                    dataEntries: values.map((v) => RadarEntry(value: v)).toList(),
                  ),
                ],
              ),
            ),
          ),
          _solveCard(
            context,
            sc,
            headline: 'Solve this next',
            body: 'Your **DP** score is lowest on the chart. Try an Easy DP today to rebalance your practice.',
            problemTitle: 'Climbing Stairs (classic 1D DP)',
            difficulty: 'Easy',
            fakeId: 'mock_dp_easy',
            tags: const ['DP', 'Beginner'],
          ),
          _solveCard(
            context,
            sc,
            headline: 'Second priority',
            body: '**Graphs** trail your other strengths. One BFS grid problem closes the gap.',
            problemTitle: 'Rotting Oranges',
            difficulty: 'Medium',
            fakeId: 'mock_graph_bfs',
            tags: const ['Graphs', 'BFS'],
          ),
        ],
      ),
    );
  }

  Widget _solveCard(
    BuildContext context,
    double sc, {
    required String headline,
    required String body,
    required String problemTitle,
    required String difficulty,
    required String fakeId,
    required List<String> tags,
  }) {
    return Container(
      margin: EdgeInsets.only(top: 14 * sc),
      padding: EdgeInsets.all(16 * sc),
      decoration: BoxDecoration(
        color: UiConstants.infoBackgroundColor,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: UiConstants.primaryButtonColor.withValues(alpha: 0.28)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.bolt_rounded, color: Colors.amberAccent, size: 22 * sc),
              SizedBox(width: 8 * sc),
              Text(
                headline,
                style: TextStyle(color: UiConstants.mainTextColor, fontSize: 15 * sc, fontWeight: FontWeight.w900),
              ),
            ],
          ),
          SizedBox(height: 8 * sc),
          Text(
            body.replaceAll('**', ''),
            style: TextStyle(color: UiConstants.subtitleTextColor, fontSize: 13 * sc, height: 1.4),
          ),
          SizedBox(height: 14 * sc),
          FilledButton.tonal(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute<void>(
                  builder: (_) => ProblemDetailsPage(
                    problemData: {
                      'title': problemTitle,
                      'difficulty': difficulty,
                      'problemId': fakeId,
                      'tags': tags,
                      'likedCount': '—',
                      'dislikedCount': '—',
                    },
                  ),
                ),
              );
            },
            child: Text('Open: $problemTitle'),
          ),
        ],
      ),
    );
  }
}
