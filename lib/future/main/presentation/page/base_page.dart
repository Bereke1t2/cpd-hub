import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:cpd_hub/core/theme/theme_ext.dart';
import '../../../../core/ui_constants.dart';

class BasePage extends StatefulWidget {
  final Widget body;
  final int selectedIndex;
  final String title;
  final String subtitle;
  final bool showBackButton;
  final bool hasSliverAppBar;

  const BasePage({
    super.key,
    required this.body,
    this.selectedIndex = 0,
    this.title = '',
    this.subtitle = '',
    this.showBackButton = false,
    this.hasSliverAppBar = false,
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

  void _onTabTap(int index) {
    if (_selectedIndex == index) return;
    final routes = ['/', '/problems', '/contests', '/users', '/profile'];
    setState(() => _selectedIndex = index);
    Navigator.pushReplacementNamed(context, routes[index]);
  }

  @override
  Widget build(BuildContext context) {
    final sc = context.sc;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: UiConstants.infoBackgroundColor.withValues(alpha: 0.75),
      appBar: widget.hasSliverAppBar ? null : PreferredSize(
        preferredSize: Size.fromHeight(64 * sc),
        child: AppBar(
          automaticallyImplyLeading: false,
          elevation: 0,
          backgroundColor: Colors.transparent,
          centerTitle: false,
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  UiConstants.primaryButtonColor,
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
                  color: Colors.black.withValues(alpha: 0.2),
                  blurRadius: 14,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: SafeArea(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16 * sc, vertical: 4),
                child: Row(
                  children: [
                    if (widget.showBackButton)
                      IconButton(
                        icon: Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 20 * sc),
                        onPressed: () => Navigator.pop(context),
                      )
                    else
                      Icon(Icons.code, color: Colors.white, size: 22 * sc),
                    SizedBox(width: 10 * sc),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.title,
                            style: TextStyle(
                              fontSize: 18 * sc,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                              letterSpacing: 0.3,
                            ),
                          ),
                          if (widget.subtitle.isNotEmpty)
                            Text(
                              widget.subtitle,
                              style: TextStyle(
                                fontSize: 11 * sc,
                                color: Colors.white.withValues(alpha: 0.75),
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
      body: Stack(
        children: [
          Positioned.fill(child: widget.body),
          Positioned(
            left: 16 * sc,
            right: 16 * sc,
            bottom: MediaQuery.of(context).padding.bottom + 12 * sc,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(28),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 6 * sc, vertical: 10 * sc),
                  decoration: BoxDecoration(
                    color: UiConstants.infoBackgroundColor.withValues(alpha: 0.85),
                    borderRadius: BorderRadius.circular(28),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.1),
                      width: 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.35),
                        blurRadius: 30,
                        spreadRadius: 2,
                        offset: const Offset(0, 8),
                      ),
                      BoxShadow(
                        color: UiConstants.primaryButtonColor.withValues(alpha: 0.06),
                        blurRadius: 20,
                        spreadRadius: -4,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildNavItem(0, Icons.home_outlined, Icons.home_rounded, 'Home', sc),
                      _buildNavItem(1, Icons.code_outlined, Icons.code_rounded, 'Problems', sc),
                      _buildNavItem(2, Icons.emoji_events_outlined, Icons.emoji_events_rounded, 'Contests', sc),
                      _buildNavItem(3, Icons.people_outline_rounded, Icons.people_rounded, 'Users', sc),
                      _buildNavItem(4, Icons.person_outline_rounded, Icons.person_rounded, 'Profile', sc),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(int index, IconData outlinedIcon, IconData filledIcon, String label, double sc) {
    final isSelected = _selectedIndex == index;
    final activeColor = UiConstants.primaryButtonColor;
    final inactiveColor = Colors.white.withValues(alpha: 0.4);

    return Expanded(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => _onTabTap(index),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOutCubic,
          padding: EdgeInsets.symmetric(vertical: 4 * sc),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOutCubic,
                padding: EdgeInsets.symmetric(
                  horizontal: isSelected ? 16 * sc : 0,
                  vertical: isSelected ? 6 * sc : 0,
                ),
                decoration: BoxDecoration(
                  color: isSelected ? activeColor.withValues(alpha: 0.15) : Colors.transparent,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 250),
                  switchInCurve: Curves.easeOutCubic,
                  child: Icon(
                    isSelected ? filledIcon : outlinedIcon,
                    key: ValueKey(isSelected),
                    color: isSelected ? activeColor : inactiveColor,
                    size: 22 * sc,
                  ),
                ),
              ),
              SizedBox(height: 4 * sc),
              AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 250),
                style: TextStyle(
                  color: isSelected ? activeColor : inactiveColor,
                  fontSize: isSelected ? 10.5 * sc : 10 * sc,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  letterSpacing: isSelected ? 0.3 : 0,
                ),
                child: Text(label),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
