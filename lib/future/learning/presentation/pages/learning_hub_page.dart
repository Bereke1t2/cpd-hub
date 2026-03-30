import 'package:flutter/material.dart';
import 'package:cpd_hub/core/theme/theme_ext.dart';
import 'package:cpd_hub/core/ui_constants.dart';
import 'package:cpd_hub/future/main/presentation/page/base_page.dart';
import 'package:cpd_hub/future/learning/presentation/pages/pocket_templates_page.dart';
import 'package:cpd_hub/future/learning/presentation/pages/roadmap_paths_page.dart';
import 'package:cpd_hub/future/learning/presentation/pages/unified_contest_calendar_page.dart';
import 'package:cpd_hub/future/learning/presentation/pages/weakness_radar_analytics_page.dart';

/// Entry to curriculum, analytics, calendar, and templates.
class LearningHubPage extends StatelessWidget {
  const LearningHubPage({super.key});

  @override
  Widget build(BuildContext context) {
    final sc = context.sc;

    final tiles = [
      _HubTile(
        'Interactive roadmap',
        'Timeline curriculum — Markdown lectures, YouTube, hand-picked practice',
        Icons.route_rounded,
        Colors.tealAccent,
        () => Navigator.push(context, MaterialPageRoute<void>(builder: (_) => const RoadmapPathsPage())),
      ),
      _HubTile(
        'Weakness radar',
        'Skill spider chart + “Solve this next” nudges (API-driven later)',
        Icons.radar_rounded,
        Colors.amberAccent,
        () => Navigator.push(context, MaterialPageRoute<void>(builder: (_) => const WeaknessRadarAnalyticsPage())),
      ),
      _HubTile(
        'Contest calendar',
        'External + CPD Hub contests — remind me & open links',
        Icons.calendar_month_rounded,
        Colors.lightBlueAccent,
        () => Navigator.push(context, MaterialPageRoute<void>(builder: (_) => const UnifiedContestCalendarPage())),
      ),
      _HubTile(
        'Pocket templates',
        'Searchable snippets — copy to clipboard',
        Icons.content_copy_rounded,
        Colors.orangeAccent,
        () => Navigator.push(context, MaterialPageRoute<void>(builder: (_) => const PocketTemplatesPage())),
      ),
    ];

    return BasePage(
      showBackButton: true,
      selectedIndex: 0,
      title: 'Learning hub',
      subtitle: 'Curriculum · analytics · contests · templates',
      body: ListView(
        padding: EdgeInsets.fromLTRB(16 * sc, 12 * sc, 16 * sc, 100 * sc),
        children: [
          Container(
            padding: EdgeInsets.all(14 * sc),
            decoration: BoxDecoration(
              color: UiConstants.primaryButtonColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: UiConstants.primaryButtonColor.withValues(alpha: 0.3)),
            ),
            child: Text(
              'Go: GET /roadmaps, user_progress, tag aggregates, CLIST merge. Flutter: [RoadmapCubit] + ContestReminderService (15 min before).',
              style: TextStyle(color: UiConstants.subtitleTextColor, fontSize: 12 * sc, height: 1.35),
            ),
          ),
          SizedBox(height: 18 * sc),
          ...tiles.map((t) => Padding(
                padding: EdgeInsets.only(bottom: 12 * sc),
                child: _HubCard(tile: t, sc: sc),
              )),
        ],
      ),
    );
  }
}

class _HubTile {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color accent;
  final VoidCallback onTap;

  _HubTile(this.title, this.subtitle, this.icon, this.accent, this.onTap);
}

class _HubCard extends StatelessWidget {
  final _HubTile tile;
  final double sc;

  const _HubCard({required this.tile, required this.sc});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: tile.onTap,
        child: Ink(
          decoration: BoxDecoration(
            color: UiConstants.infoBackgroundColor,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: UiConstants.borderColor.withValues(alpha: 0.12)),
          ),
          padding: EdgeInsets.all(16 * sc),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(12 * sc),
                decoration: BoxDecoration(
                  color: tile.accent.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(tile.icon, color: tile.accent, size: 28 * sc),
              ),
              SizedBox(width: 14 * sc),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      tile.title,
                      style: TextStyle(
                        color: UiConstants.mainTextColor,
                        fontSize: 16 * sc,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    SizedBox(height: 4 * sc),
                    Text(
                      tile.subtitle,
                      style: TextStyle(
                        color: UiConstants.subtitleTextColor,
                        fontSize: 12 * sc,
                        height: 1.3,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right_rounded, color: UiConstants.subtitleTextColor.withValues(alpha: 0.4)),
            ],
          ),
        ),
      ),
    );
  }
}
