import 'package:flutter/material.dart';
import 'package:lab_portal/core/routing/route_names.dart';
import 'package:lab_portal/core/theme/app_dimens.dart';
import 'package:lab_portal/core/theme/responsive.dart';
import '../../../../core/ui_constants.dart';

class BasePage extends StatefulWidget {
  final Widget body;
  final int selectedIndex;
  final String title;
  final String subtitle;

  /// Set false to hide the default gradient AppBar.
  final bool showDefaultAppBar;

  /// Optional widget shown on the right side of the AppBar (e.g. avatar).
  final Widget? appBarTrailing;

  const BasePage({
    super.key,
    required this.body,
    this.selectedIndex = 0,
    required this.title,
    required this.subtitle,
    this.showDefaultAppBar = true,
    this.appBarTrailing,
  });

  @override
  State<BasePage> createState() => _BasePageState();
}

class _BasePageState extends State<BasePage> {
  late int _selectedIndex;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.selectedIndex;
  }

  @override
  void didUpdateWidget(covariant BasePage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedIndex != widget.selectedIndex) {
      _selectedIndex = widget.selectedIndex;
    }
  }

  @override
  Widget build(BuildContext context) {
    final r = context.r;
    return Scaffold(
      backgroundColor: UiConstants.infoBackgroundColor.withValues(alpha: 0.75),
      appBar: widget.showDefaultAppBar ? PreferredSize(
        preferredSize: const Size.fromHeight(80),
        child: AppBar(
          automaticallyImplyLeading: false,
          elevation: 0,
          backgroundColor: Colors.transparent,
          centerTitle: false,
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  UiConstants.primaryButtonColor,
                  UiConstants.infoBackgroundColor,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(AppDimens.rLg),
                bottomRight: Radius.circular(AppDimens.rLg),
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
                padding: const EdgeInsets.symmetric(
                    horizontal: AppDimens.lg, vertical: AppDimens.xs),
                child: Row(
                  children: [
                    const Icon(Icons.code,
                        color: Colors.white, size: AppDimens.iconLg),
                    const SizedBox(width: AppDimens.md),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.title,
                            style: TextStyle(
                              fontSize: r.sp(AppDimens.fHero),
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                              letterSpacing: 0.5,
                            ),
                          ),
                          if (widget.subtitle.isNotEmpty)
                            Text(
                              widget.subtitle,
                              style: TextStyle(
                                fontSize: r.sp(AppDimens.fCaption),
                                color: Colors.white.withValues(alpha: 0.85),
                              ),
                            ),
                        ],
                      ),
                    ),
                    if (widget.appBarTrailing != null) ...[
                      const SizedBox(width: AppDimens.md),
                      widget.appBarTrailing!,
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
      ) : null,
      bottomNavigationBar: Container(
        margin: const EdgeInsets.fromLTRB(
            AppDimens.md, 0, AppDimens.md, AppDimens.md),
        decoration: BoxDecoration(
          color: UiConstants.infoBackgroundColor.withValues(alpha: 0.92),
          borderRadius: const BorderRadius.all(Radius.circular(AppDimens.rLg)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.18),
              blurRadius: 24,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(AppDimens.rLg)),
          child: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            backgroundColor: Colors.transparent,
            elevation: 0,
            currentIndex: _selectedIndex,
            selectedItemColor: UiConstants.primaryButtonColor,
            unselectedItemColor: UiConstants.subtitleTextColor,
            showUnselectedLabels: false,
            selectedFontSize: AppDimens.fCaption,
            unselectedFontSize: AppDimens.fCaption,
            selectedIconTheme: const IconThemeData(size: AppDimens.iconLg),
            unselectedIconTheme: const IconThemeData(size: AppDimens.iconMd),
            onTap: (index) {
              if (index == _selectedIndex) return;
              setState(() => _selectedIndex = index);
              const routes = [
                RouteNames.home,
                RouteNames.problems,
                RouteNames.learn,
                RouteNames.contests,
                RouteNames.users,
                RouteNames.profile,
              ];
              if (index < routes.length) {
                Navigator.pushReplacementNamed(context, routes[index]);
              }
            },
            items: [
              _navItem(Icons.home_outlined, Icons.home, 'Home'),
              _navItem(Icons.code_outlined, Icons.code_outlined, 'Problems'),
              _navItem(Icons.school_outlined, Icons.school_rounded, 'Learn'),
              _navItem(Icons.emoji_events_outlined, Icons.emoji_events, 'Contests'),
              _navItem(Icons.people_outline, Icons.people, 'Users'),
              _navItem(Icons.person_outline, Icons.person, 'Profile'),
            ],
          ),
        ),
      ),
      // Responsive shell: center content at contentMaxWidth on wide screens.
      body: Align(
        alignment: Alignment.topCenter,
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: r.contentMaxWidth),
          child: widget.body,
        ),
      ),
    );
  }

  BottomNavigationBarItem _navItem(
      IconData outline, IconData filled, String label) {
    return BottomNavigationBarItem(
      icon: Icon(outline),
      activeIcon: Container(
        padding: const EdgeInsets.symmetric(
            horizontal: AppDimens.lg, vertical: AppDimens.sm),
        decoration: BoxDecoration(
          color: UiConstants.primaryButtonColor.withValues(alpha: 0.18),
          borderRadius: AppDimens.brLg,
        ),
        child: Icon(filled),
      ),
      label: label,
    );
  }
}
