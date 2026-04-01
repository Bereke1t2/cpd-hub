import 'package:flutter/material.dart';
import 'package:cpd_hub/core/theme/theme_ext.dart';
import 'package:cpd_hub/core/ui_constants.dart';
import 'package:cpd_hub/future/main/presentation/page/base_page.dart';
import 'package:cpd_hub/future/main/presentation/page/problems_page.dart';
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

    return BasePage(
      showBackButton: false,
      selectedIndex: 1, // Explore is index 1
      title: 'Explore',
      subtitle: 'Your central command for CP growth',
      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(16 * sc, 16 * sc, 16 * sc, 100 * sc),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeroCard(context, sc),
            SizedBox(height: 24 * sc),
            Text(
              'Practice & Play',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18 * sc,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: 12 * sc),
            // Redirects to standard problems page
            _buildProblemsCard(context, sc),
            SizedBox(height: 24 * sc),
            Text(
              'Explore Resources',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18 * sc,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: 12 * sc),
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 12 * sc,
              crossAxisSpacing: 12 * sc,
              childAspectRatio: 0.9,
              children: [
                _buildGridCard(
                  sc: sc,
                  title: 'Weakness Radar',
                  subtitle: 'Targeted skill analysis',
                  icon: Icons.radar_rounded,
                  accentUrl: UiConstants.secondaryButtonColor,
                  imageUrl: 'assets/images/radar_bg.png',
                  gradientColors: [Color(0xFF6A1B9A), Color(0xFF4A148C)],
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute<void>(
                      builder: (_) => const WeaknessRadarAnalyticsPage(),
                    ),
                  ),
                ),
                _buildGridCard(
                  sc: sc,
                  title: 'Contest Calendar',
                  subtitle: 'Upcoming CP events',
                  icon: Icons.calendar_month_rounded,
                  accentUrl: UiConstants.secondaryButtonColor,
                  imageUrl: 'assets/images/calendar_bg.png',
                  gradientColors: [Color(0xFF1565C0), Color(0xFF0D47A1)],
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute<void>(
                      builder: (_) => const UnifiedContestCalendarPage(),
                    ),
                  ),
                ),
                _buildGridCard(
                  sc: sc,
                  title: 'Pocket Templates',
                  subtitle: 'Searchable snippets',
                  icon: Icons.content_copy_rounded,
                  accentUrl: UiConstants.secondaryButtonColor,
                  imageUrl: 'assets/images/templates_bg.png',
                  gradientColors: [Color(0xFF00695C), Color(0xFF004D40)],
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute<void>(
                      builder: (_) => const PocketTemplatesPage(),
                    ),
                  ),
                ),
                _buildGridCard(
                  sc: sc,
                  title: 'Daily Challenge',
                  subtitle: 'Solve to keep your streak',
                  icon: Icons.local_fire_department_rounded,
                  accentUrl: UiConstants.secondaryButtonColor,
                  imageUrl: 'assets/images/challenge_bg.png',
                  gradientColors: [Color(0xFFE65100), Color(0xFFBF360C)],
                  onTap: () {}, // Placeholder
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProblemsCard(BuildContext context, double sc) {
    return InkWell(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute<void>(builder: (_) => const ProblemsPage()),
      ),
      borderRadius: BorderRadius.circular(20),
      child: Ink(
        padding: EdgeInsets.all(16 * sc),
        decoration: BoxDecoration(
          color: UiConstants.primaryButtonColor.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: UiConstants.primaryButtonColor.withValues(alpha: 0.15)),
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(12 * sc),
              decoration: BoxDecoration(
                color: UiConstants.primaryButtonColor.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.code_rounded,
                color: UiConstants.primaryButtonColor,
                size: 28 * sc,
              ),
            ),
            SizedBox(width: 16 * sc),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Practice Problems',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16 * sc,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4 * sc),
                  Text(
                    'Access CP problems and past contests',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.9),
                      fontSize: 13 * sc,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right_rounded, color: Colors.white),
          ],
        ),
      ),
    );
  }
  Widget _buildHeroCard(BuildContext context, double sc) {
    return InkWell(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute<void>(builder: (_) => const RoadmapPathsPage()),
      ),
      borderRadius: BorderRadius.circular(24),
      child: Ink(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              UiConstants.primaryButtonColor,
              UiConstants.infoBackgroundColor,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.2),
              blurRadius: 14,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Container(
          padding: EdgeInsets.all(20 * sc),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            color: UiConstants.primaryButtonColor.withValues(alpha: 0.05), // subtle overlay so text is readable
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.route_rounded, color: Colors.white, size: 32 * sc),
                  const Spacer(),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 10 * sc,
                      vertical: 4 * sc,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      'Recommended',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10 * sc,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16 * sc),
              Text(
                'Interactive Roadmap',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22 * sc,
                  fontWeight: FontWeight.w800,
                ),
              ),
              SizedBox(height: 8 * sc),
              Text(
                'Timeline curriculum featuring Markdown lectures, hand-picked practice, and YouTube tutorials.',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.9),
                  fontSize: 13 * sc,
                  height: 1.4,
                ),
              ),
              SizedBox(height: 16 * sc),
              Row(
                children: [
                  Text(
                    'Start Learning',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14 * sc,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(width: 4 * sc),
                  Icon(
                    Icons.arrow_forward_rounded,
                    color: Colors.white,
                    size: 16 * sc,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGridCard({
    required double sc,
    required String title,
    required String subtitle,
    required IconData icon,
    required Color accentUrl,
    required String imageUrl,
    List<Color>? gradientColors,
    required VoidCallback onTap,
  }) {
    final baseColor = gradientColors?.first ?? UiConstants.primaryButtonColor;
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(20),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Ink(
          decoration: BoxDecoration(
            color: baseColor.withValues(alpha: 0.25),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: baseColor.withValues(alpha: 0.6),
              width: 1.5,
            ),
            image: DecorationImage(
              image: AssetImage(imageUrl),
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(
                Colors.black.withValues(alpha: 0.35),
                BlendMode.dstATop,
              ),
            ),
            boxShadow: [
              BoxShadow(
                color: baseColor.withValues(alpha: 0.25),
                blurRadius: 16,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Padding(
            padding: EdgeInsets.all(16 * sc),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: EdgeInsets.all(12 * sc),
                  decoration: BoxDecoration(
                    color: baseColor.withValues(alpha: 0.4),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: baseColor.withValues(alpha: 0.3),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Icon(icon, color: baseColor.withValues(alpha: 1.0), size: 28 * sc),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15 * sc,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 4 * sc),
                    Text(
                      subtitle,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.9),
                        fontSize: 12 * sc,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
