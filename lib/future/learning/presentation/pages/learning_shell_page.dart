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
              image: _tab == 0 
                ? null 
                : const DecorationImage(
                    image: NetworkImage('data:image/jpeg;base64,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'),
                    fit: BoxFit.cover,
                    colorFilter: ColorFilter.mode(Colors.black54, BlendMode.darken),
                  ),
              gradient: _tab == 0 
                ? LinearGradient(
                    colors: [
                      const Color(0xFF0D4D2E),
                      UiConstants.primaryButtonColor.withValues(alpha: 0.85),
                      UiConstants.infoBackgroundColor,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  )
                : LinearGradient(
                    colors: [
                      UiConstants.infoBackgroundColor.withValues(alpha: 0.9),
                      UiConstants.infoBackgroundColor.withValues(alpha: 0.7),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
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
          LearningHubPage(),
          Navigator(
            key: _roadmapNavKey,
            initialRoute: 'paths',
            onGenerateRoute: _roadmapOnGenerateRoute,
          ),
          const WeaknessRadarAnalyticsPage(),
          const UnifiedContestCalendarPage(),
          const PocketTemplatesPage(),
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
