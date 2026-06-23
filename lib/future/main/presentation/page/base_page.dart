import 'dart:ui';
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
      // extendBody lets the content scroll behind the floating nav bar so
      // there is no dead empty gap between the last item and the nav bar.
      extendBody: true,
      appBar: widget.showDefaultAppBar
          ? PreferredSize(
              preferredSize: Size.fromHeight(r.sp(80).clamp(80, 112)),
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
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
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
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: r.sp(AppDimens.fCaption),
                                      color:
                                          Colors.white.withValues(alpha: 0.85),
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
            )
          : null,

      // ── Floating frosted-glass nav bar ─────────────────────────────────────
      bottomNavigationBar: _FloatingNavBar(
        selectedIndex: _selectedIndex,
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
      ),

      // Responsive content shell.
      body: Align(
        alignment: Alignment.topCenter,
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: r.contentMaxWidth),
          child: widget.body,
        ),
      ),
    );
  }
}

// ── Floating frosted-glass navigation bar ─────────────────────────────────────

class _FloatingNavBar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onTap;

  const _FloatingNavBar({
    required this.selectedIndex,
    required this.onTap,
  });

  static const _routes = [
    _NavDef(Icons.home_outlined, Icons.home_rounded, 'Home'),
    _NavDef(Icons.code_outlined, Icons.code_rounded, 'Problems'),
    _NavDef(Icons.school_outlined, Icons.school_rounded, 'Learn'),
    _NavDef(Icons.emoji_events_outlined, Icons.emoji_events_rounded, 'Contests'),
    _NavDef(Icons.people_outline_rounded, Icons.people_rounded, 'Users'),
    _NavDef(Icons.person_outline_rounded, Icons.person_rounded, 'Profile'),
  ];

  @override
  Widget build(BuildContext context) {
    // SafeArea bottom keeps the bar above the home indicator on iOS.
    final bottomPad = MediaQuery.of(context).padding.bottom;
    return Padding(
      padding: EdgeInsets.fromLTRB(
          AppDimens.md, 0, AppDimens.md, AppDimens.md + bottomPad),
      child: ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(AppDimens.rLg)),
        child: BackdropFilter(
          // Frosted-glass blur — the body scrolls behind this.
          filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
          child: Container(
            height: 62,
            decoration: BoxDecoration(
              // Translucent surface so the blur actually shows through.
              color: UiConstants.infoBackgroundColor.withValues(alpha: 0.78),
              borderRadius:
                  const BorderRadius.all(Radius.circular(AppDimens.rLg)),
              border: Border.all(
                color: UiConstants.primaryButtonColor.withValues(alpha: 0.14),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.28),
                  blurRadius: 28,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Row(
              children: [
                for (int i = 0; i < _routes.length; i++)
                  Expanded(
                    child: _NavItem(
                      def: _routes[i],
                      selected: i == selectedIndex,
                      onTap: () => onTap(i),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ── Single nav item with animated pill indicator ───────────────────────────────

class _NavItem extends StatelessWidget {
  final _NavDef def;
  final bool selected;
  final VoidCallback onTap;

  const _NavItem({
    required this.def,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = selected
        ? UiConstants.primaryButtonColor
        : UiConstants.subtitleTextColor;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOutCubic,
            padding: EdgeInsets.symmetric(
              horizontal: selected ? AppDimens.md : AppDimens.sm,
              vertical: AppDimens.xs,
            ),
            decoration: BoxDecoration(
              color: selected
                  ? UiConstants.primaryButtonColor.withValues(alpha: 0.18)
                  : Colors.transparent,
              borderRadius:
                  const BorderRadius.all(Radius.circular(AppDimens.rPill)),
            ),
            child: Icon(
              selected ? def.filledIcon : def.outlineIcon,
              color: color,
              size: selected ? AppDimens.iconLg : AppDimens.iconMd,
            ),
          ),
          if (selected)
            Padding(
              padding: const EdgeInsets.only(top: 2),
              child: Text(
                def.label,
                style: TextStyle(
                  color: color,
                  fontSize: 9,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.3,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _NavDef {
  final IconData outlineIcon;
  final IconData filledIcon;
  final String label;
  const _NavDef(this.outlineIcon, this.filledIcon, this.label);
}
