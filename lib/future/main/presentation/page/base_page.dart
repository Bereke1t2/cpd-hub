import 'package:flutter/material.dart';
import '../../../../core/ui_constants.dart';

class BasePage extends StatefulWidget {
  final Widget body;
  final int selectedIndex;
  final String title;
  final String subtitle;

  const BasePage({
    super.key,
    required this.body,
    this.selectedIndex = 0,
    required this.title,
    required this.subtitle,
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
    return Scaffold(
      backgroundColor: UiConstants.infoBackgroundColor.withOpacity(0.75),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(90),
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
                bottomLeft: Radius.circular(28),
                bottomRight: Radius.circular(28),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.25),
                  blurRadius: 18,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                child: Row(
                  children: [
                    const Icon(Icons.code, color: Colors.white, size: 30),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.title,
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                              letterSpacing: 0.5,
                            ),
                          ),
                          Text(
                            widget.subtitle,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.white.withOpacity(0.85),
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
      bottomNavigationBar: Container(
        margin: const EdgeInsets.fromLTRB(12, 0, 12, 12),
        decoration: BoxDecoration(
          color: UiConstants.infoBackgroundColor.withOpacity(0.92),
          borderRadius: const BorderRadius.all(Radius.circular(28)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.18),
              blurRadius: 24,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(28)),
          child: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            backgroundColor: Colors.transparent,
            elevation: 0,
            currentIndex: _selectedIndex,
            selectedItemColor: UiConstants.primaryButtonColor,
            unselectedItemColor: UiConstants.subtitleTextColor,
            showUnselectedLabels: false,
            selectedFontSize: 12,
            unselectedFontSize: 12,
            selectedIconTheme: const IconThemeData(size: 30),
            unselectedIconTheme: const IconThemeData(size: 24),
            onTap: (index) {
              setState(() {
                _selectedIndex = index;
              });
              if (index == 0) {
                Navigator.pushReplacementNamed(context, '/');
              } else if (index == 1) {
                Navigator.pushReplacementNamed(context, '/problems');
              }else if (index == 2) {
                Navigator.pushReplacementNamed(context, '/contests');
              } else if (index == 3) {
                Navigator.pushReplacementNamed(context, '/users');
              } else if (index == 4) {
                Navigator.pushReplacementNamed(context, '/profile');
              }
            },
            items: [
              BottomNavigationBarItem(
                icon: const Icon(Icons.home_outlined),
                activeIcon: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: UiConstants.primaryButtonColor.withOpacity(0.18),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: const Icon(Icons.home),
                ),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(IconData(0xe0cc, fontFamily: 'MaterialIcons')),
                activeIcon: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: UiConstants.primaryButtonColor.withOpacity(0.18),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Icon(IconData(0xe0cc, fontFamily: 'MaterialIcons')),
                ),
                label: 'Problems',
              ),
              BottomNavigationBarItem(
                icon: const Icon(Icons.emoji_events_outlined),
                activeIcon: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: UiConstants.primaryButtonColor.withOpacity(0.18),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: const Icon(Icons.emoji_events),
                ),
                label: 'Contests',
              ),
              BottomNavigationBarItem(
                icon: const Icon(Icons.people_outline),
                activeIcon: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: UiConstants.primaryButtonColor.withOpacity(0.18),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: const Icon(Icons.people),
                ),
                label: 'Users',
              ),
              BottomNavigationBarItem(
                icon: const Icon(Icons.person_outline),
                activeIcon: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: UiConstants.primaryButtonColor.withOpacity(0.18),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: const Icon(Icons.person),
                ),
                label: 'Profile',
              ),
            ],
          ),
        ),
      ),
      body: widget.body,
    );
  }
}