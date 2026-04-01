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
      selectedIndex: 1,
      title: 'Weakness radar',
      subtitle: 'Discover where your skills are lacking',
      body: ListView(
        padding: EdgeInsets.fromLTRB(16 * sc, 8 * sc, 16 * sc, 100 * sc),
        children: [
          Container(
            padding: EdgeInsets.all(16 * sc),
            decoration: BoxDecoration(
              color: Color(0xFF6A1B9A).withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Color(0xFF6A1B9A).withValues(alpha: 0.4), width: 1.5),
            ),
            child: Row(
              children: [
                Icon(Icons.lightbulb_outline_rounded, color: Color(0xFFAB47BC), size: 28 * sc),
                SizedBox(width: 12 * sc),
                Expanded(
                  child: Text(
                    'Your weakness analytics map. Mastering lower scored tags will significantly increase your overall rating.',
                    style: TextStyle(color: Colors.white.withValues(alpha: 0.9), fontSize: 13 * sc, height: 1.4),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 32 * sc),
          Container(
            height: 320 * sc,
            padding: EdgeInsets.symmetric(vertical: 24 * sc),
            decoration: BoxDecoration(
              color: UiConstants.infoBackgroundColor.withValues(alpha: 0.4),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.2),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: RadarChart(
              RadarChartData(
                radarShape: RadarShape.polygon,
                tickCount: 5,
                ticksTextStyle: const TextStyle(color: Colors.transparent, fontSize: 0),
                tickBorderData: const BorderSide(color: Colors.white10, width: 1),
                gridBorderData: const BorderSide(color: Colors.white10, width: 1.5),
                radarBorderData: BorderSide(color: Color(0xFF6A1B9A).withValues(alpha: 0.7), width: 2),
                titleTextStyle: TextStyle(color: Colors.white, fontSize: 12 * sc, fontWeight: FontWeight.bold),
                getTitle: (index, angle) {
                  if (index >= 0 && index < _tags.length) {
                    return RadarChartTitle(text: _tags[index], angle: angle);
                  }
                  return const RadarChartTitle(text: '');
                },
                dataSets: [
                  RadarDataSet(
                    fillColor: Color(0xFF4A148C).withValues(alpha: 0.5),
                    borderColor: Color(0xFFAB47BC),
                    entryRadius: 4.0,
                    borderWidth: 3,
                    dataEntries: values.map((v) => RadarEntry(value: v)).toList(),
                  ),
                ],
                radarBackgroundColor: Colors.transparent,
              ),
            ),
          ),
          SizedBox(height: 24 * sc),
          Text(
            'Targeted Practice Session',
            style: TextStyle(color: Colors.white, fontSize: 18 * sc, fontWeight: FontWeight.w800),
          ),
          SizedBox(height: 8 * sc),
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
    return InkWell(
      onTap: () {
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
      borderRadius: BorderRadius.circular(20),
      child: Container(
        margin: EdgeInsets.only(top: 14 * sc),
        child: Ink(
          padding: EdgeInsets.all(20 * sc),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                UiConstants.infoBackgroundColor.withValues(alpha: 0.6),
                UiConstants.infoBackgroundColor.withValues(alpha: 0.2),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white.withValues(alpha: 0.1), width: 1.5),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.2),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(8 * sc),
                    decoration: BoxDecoration(
                      color: Colors.amberAccent.withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.bolt_rounded, color: Colors.amberAccent, size: 20 * sc),
                  ),
                  SizedBox(width: 12 * sc),
                  Expanded(
                    child: Text(
                      headline,
                      style: TextStyle(color: Colors.white, fontSize: 16 * sc, fontWeight: FontWeight.w800),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10 * sc, vertical: 4 * sc),
                    decoration: BoxDecoration(
                      color: difficulty == 'Easy' 
                          ? Colors.green.withValues(alpha: 0.2)
                          : (difficulty == 'Medium' ? Colors.orange.withValues(alpha: 0.2) : Colors.red.withValues(alpha: 0.2)),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: difficulty == 'Easy' ? Colors.green : (difficulty == 'Medium' ? Colors.orange : Colors.red),
                      )
                    ),
                    child: Text(
                      difficulty,
                      style: TextStyle(
                        color: difficulty == 'Easy' ? Colors.greenAccent : (difficulty == 'Medium' ? Colors.orangeAccent : Colors.redAccent),
                        fontSize: 10 * sc,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16 * sc),
              Text(
                body.replaceAll('**', ''),
                style: TextStyle(color: Colors.white.withValues(alpha: 0.85), fontSize: 13 * sc, height: 1.5),
              ),
              SizedBox(height: 20 * sc),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    problemTitle,
                    style: TextStyle(color: Colors.white, fontSize: 15 * sc, fontWeight: FontWeight.bold),
                  ),
                  Icon(Icons.arrow_forward_rounded, color: Colors.white.withValues(alpha: 0.6), size: 20 * sc),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
