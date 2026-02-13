import 'package:flutter/material.dart';
import 'package:cpd_hub/core/ui_constants.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    _navigateToLogin();
  }

  void _navigateToLogin() async {
    await Future.delayed(const Duration(seconds: 3));
    if (mounted) {
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: UiConstants.infoBackgroundColor.withOpacity(0.75),
      body: Column(
        children: [
          // Gradient Header (matches BasePage)
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [UiConstants.primaryButtonColor, UiConstants.infoBackgroundColor],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(28),
                bottomRight: Radius.circular(28),
              ),
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.25), blurRadius: 18, offset: const Offset(0, 6)),
              ],
            ),
            child: const SafeArea(bottom: false, child: SizedBox(height: 20)),
          ),

          // Center Content
          Expanded(
            child: Center(
              child: TweenAnimationBuilder<double>(
                tween: Tween<double>(begin: 0.0, end: 1.0),
                duration: const Duration(milliseconds: 1200),
                curve: Curves.easeOutQuart,
                builder: (context, value, child) {
                  return Opacity(
                    opacity: value,
                    child: Transform.translate(
                      offset: Offset(0, 20 * (1 - value)),
                      child: child,
                    ),
                  );
                },
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: UiConstants.infoBackgroundColor,
                        shape: BoxShape.circle,
                        border: Border.all(color: UiConstants.primaryButtonColor.withOpacity(0.2)),
                      ),
                      child: Image.asset('assets/images/logo.png', width: 80, height: 80),
                    ),
                    const SizedBox(height: 36),
                    const Text(
                      'CPD HUB',
                      style: TextStyle(color: UiConstants.mainTextColor, fontSize: 44, fontWeight: FontWeight.w900, letterSpacing: -1.5),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: UiConstants.primaryButtonColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text(
                        'COMPETITIVE PROGRAMMING DIVISION',
                        style: TextStyle(color: UiConstants.primaryButtonColor, fontSize: 10, fontWeight: FontWeight.w900, letterSpacing: 1.5),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Bottom Loading
          Padding(
            padding: const EdgeInsets.only(bottom: 60),
            child: SizedBox(
              width: 28,
              height: 28,
              child: CircularProgressIndicator(
                strokeWidth: 2.5,
                color: UiConstants.primaryButtonColor,
                backgroundColor: UiConstants.borderColor.withOpacity(0.15),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
