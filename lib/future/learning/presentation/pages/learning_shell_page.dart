import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:cpd_hub/core/theme/theme_ext.dart';
import 'package:cpd_hub/core/ui_constants.dart';
import 'package:cpd_hub/future/learning/presentation/pages/learning_hub_page.dart';
import 'package:cpd_hub/future/learning/presentation/pages/pocket_templates_page.dart';
import 'package:cpd_hub/future/learning/presentation/pages/roadmap_paths_page.dart';
import 'package:cpd_hub/future/learning/presentation/pages/roadmap_timeline_page.dart';
import 'package:cpd_hub/future/learning/presentation/pages/unified_contest_calendar_page.dart';
import 'package:cpd_hub/future/learning/presentation/pages/weakness_radar_analytics_page.dart';

/// Learning area with its own bottom navigation (separate from the main app tabs).
class LearningShellPage extends StatefulWidget {
  const LearningShellPage({super.key});

  @override
  State<LearningShellPage> createState() => _LearningShellPageState();
}

class _LearningShellPageState extends State<LearningShellPage> {
  int _tab = 0;
  final GlobalKey<NavigatorState> _roadmapNavKey = GlobalKey<NavigatorState>();

  static const _titles = ['Learning hub', 'Roadmap', 'Weakness radar', 'Contest calendar', 'Pocket templates'];
  static const _subtitles = [
    'Curriculum, analytics, and templates',
    'Paths, timeline, and practice checklist',
    'Skill balance and next problems',
    'Reminders and quick links',
    'Copy-ready contest snippets',
  ];

  void _goToTab(int index) {
    if (index == 1) {
      _roadmapNavKey.currentState?.popUntil((r) => r.isFirst);
    }
    setState(() => _tab = index);
  }

  Route<dynamic> _roadmapOnGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case 'timeline':
        return MaterialPageRoute<void>(
          settings: settings,
          builder: (_) => const RoadmapTimelinePage(),
        );
      case 'paths':
      default:
        return MaterialPageRoute<void>(
          settings: settings,
          builder: (_) => const RoadmapPathsPage(),
        );
    }
  }

  void _onLeadingPressed() {
    if (_tab == 1) {
      final nav = _roadmapNavKey.currentState;
      if (nav != null && nav.canPop()) {
        nav.pop();
        return;
      }
    }
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final sc = context.sc;
    final showNestedBack = _tab == 1 && (_roadmapNavKey.currentState?.canPop() ?? false);

    return Scaffold(
      backgroundColor: UiConstants.infoBackgroundColor.withValues(alpha: 0.75),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(64 * sc),
        child: AppBar(
          automaticallyImplyLeading: false,
          elevation: 0,
          backgroundColor: Colors.transparent,
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color(0xFF0D4D2E),
                  UiConstants.primaryButtonColor.withValues(alpha: 0.85),
                  UiConstants.infoBackgroundColor,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(24),
                bottomRight: Radius.circular(24),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.25),
                  blurRadius: 18,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: SafeArea(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 14 * sc, vertical: 4),
                child: Row(
                  children: [
                    IconButton(
                      icon: Icon(
                        showNestedBack ? Icons.arrow_back_ios_new_rounded : Icons.arrow_back_ios_new_rounded,
                        color: Colors.white,
                        size: 20 * sc,
                      ),
                      onPressed: _onLeadingPressed,
                    ),
                    SizedBox(width: 6 * sc),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _titles[_tab],
                            style: TextStyle(
                              fontSize: 18 * sc,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                              letterSpacing: 0.2,
                            ),
                          ),
                          Text(
                            _subtitles[_tab],
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 11 * sc,
                              color: Colors.white.withValues(alpha: 0.82),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      body: IndexedStack(
        index: _tab,
        alignment: Alignment.topCenter,
        children: [
          LearningHubTab(onOpenSection: _goToTab),
          Navigator(
            key: _roadmapNavKey,
            initialRoute: 'paths',
            onGenerateRoute: _roadmapOnGenerateRoute,
          ),
          const WeaknessRadarAnalyticsTab(),
          const UnifiedContestCalendarTab(),
          const PocketTemplatesTab(),
        ],
      ),
      bottomNavigationBar: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Material(
            color: UiConstants.infoBackgroundColor.withValues(alpha: 0.92),
            child: SafeArea(
              child: Padding(
                padding: EdgeInsets.fromLTRB(8 * sc, 6 * sc, 8 * sc, 6 * sc),
                child: NavigationBar(
                  height: 64 * sc,
                  backgroundColor: Colors.transparent,
                  indicatorColor: UiConstants.primaryButtonColor.withValues(alpha: 0.22),
                  labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
                  selectedIndex: _tab,
                  onDestinationSelected: _goToTab,
                  destinations: [
                    NavigationDestination(
                      icon: Icon(Icons.dashboard_outlined, size: 22 * sc),
                      selectedIcon: Icon(Icons.dashboard_rounded, size: 22 * sc, color: UiConstants.primaryButtonColor),
                      label: 'Hub',
                    ),
                    NavigationDestination(
                      icon: Icon(Icons.route_outlined, size: 22 * sc),
                      selectedIcon: Icon(Icons.route_rounded, size: 22 * sc, color: UiConstants.primaryButtonColor),
                      label: 'Roadmap',
                    ),
                    NavigationDestination(
                      icon: Icon(Icons.radar_outlined, size: 22 * sc),
                      selectedIcon: Icon(Icons.radar_rounded, size: 22 * sc, color: UiConstants.primaryButtonColor),
                      label: 'Radar',
                    ),
                    NavigationDestination(
                      icon: Icon(Icons.calendar_month_outlined, size: 22 * sc),
                      selectedIcon: Icon(Icons.calendar_month_rounded, size: 22 * sc, color: UiConstants.primaryButtonColor),
                      label: 'Calendar',
                    ),
                    NavigationDestination(
                      icon: Icon(Icons.auto_awesome_motion_outlined, size: 22 * sc),
                      selectedIcon: Icon(Icons.auto_awesome_motion_rounded, size: 22 * sc, color: UiConstants.primaryButtonColor),
                      label: 'Templates',
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
