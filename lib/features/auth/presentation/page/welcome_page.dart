import 'package:flutter/material.dart';
import 'package:lab_portal/core/theme/app_dimens.dart';
import 'package:lab_portal/core/ui_constants.dart';
import 'login_page.dart';
import 'register_page.dart';

/// The first screen new users see — brand story, two CTAs.
class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _fade;
  late final Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..forward();

    _fade = CurvedAnimation(parent: _ctrl, curve: Curves.easeOut);
    _slide = Tween<Offset>(
      begin: const Offset(0, 0.06),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOut));
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _goLogin() => Navigator.push(
        context,
        PageRouteBuilder(
          pageBuilder: (_, __, ___) => const LoginPage(),
          transitionDuration: const Duration(milliseconds: 260),
          transitionsBuilder: (_, a, __, child) =>
              FadeTransition(opacity: a, child: child),
        ),
      );

  void _goRegister() => Navigator.push(
        context,
        PageRouteBuilder(
          pageBuilder: (_, __, ___) => const RegisterPage(),
          transitionDuration: const Duration(milliseconds: 260),
          transitionsBuilder: (_, a, __, child) =>
              FadeTransition(opacity: a, child: child),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: UiConstants.backgroundColor,
      body: Stack(
        children: [
          // ── Background: large radial glow top-right ─────────────────────
          Positioned(
            top: -160,
            right: -160,
            child: Container(
              width: 500,
              height: 500,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    UiConstants.primaryButtonColor.withValues(alpha: 0.25),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          // Smaller glow bottom-left
          Positioned(
            bottom: -80,
            left: -80,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    UiConstants.primaryDark.withValues(alpha: 0.20),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),

          // ── Foreground content ───────────────────────────────────────────
          SafeArea(
            child: FadeTransition(
              opacity: _fade,
              child: SlideTransition(
                position: _slide,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 28),
                  child: Column(
                    children: [
                      const Spacer(flex: 2),

                      // ── Hero logo ─────────────────────────────────────
                      _HeroGlyph(),
                      const SizedBox(height: 28),

                      // ── Headline ──────────────────────────────────────
                      const Text(
                        'CPD Hub',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: UiConstants.mainTextColor,
                          fontSize: 40,
                          fontWeight: FontWeight.w900,
                          letterSpacing: -1,
                          height: 1.0,
                        ),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'Your competitive programming home.\nSolve. Track. Improve. Repeat.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: UiConstants.subtitleTextColor,
                          fontSize: 15,
                          height: 1.55,
                        ),
                      ),

                      const Spacer(flex: 2),

                      // ── Feature pills ─────────────────────────────────
                      _FeaturePills(),
                      const SizedBox(height: 40),

                      // ── Primary CTA: Create account ───────────────────
                      SizedBox(
                        height: 54,
                        width: double.infinity,
                        child: FilledButton(
                          onPressed: _goRegister,
                          style: FilledButton.styleFrom(
                            backgroundColor: UiConstants.primaryButtonColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            elevation: 0,
                          ),
                          child: const Text(
                            'Get started — it\'s free',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 0.2,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 14),

                      // ── Secondary CTA: Sign in ────────────────────────
                      SizedBox(
                        height: 54,
                        width: double.infinity,
                        child: OutlinedButton(
                          onPressed: _goLogin,
                          style: OutlinedButton.styleFrom(
                            foregroundColor: UiConstants.primaryButtonColor,
                            side: BorderSide(
                              color: UiConstants.primaryButtonColor
                                  .withValues(alpha: 0.45),
                              width: 1.5,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: const Text(
                            'I already have an account',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 32),

                      // Fine print
                      Text(
                        'By continuing you agree to CPD Hub\'s terms.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: UiConstants.subtitleTextColor
                              .withValues(alpha: 0.55),
                          fontSize: 11,
                        ),
                      ),
                      const SizedBox(height: 16),
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
}

// ── Animated hero glyph ───────────────────────────────────────────────────────

class _HeroGlyph extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Outer ring (decorative)
        Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: UiConstants.primaryButtonColor.withValues(alpha: 0.15),
              width: 1.5,
            ),
          ),
        ),
        // Middle ring
        Container(
          width: 96,
          height: 96,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: UiConstants.primaryButtonColor.withValues(alpha: 0.25),
              width: 1.5,
            ),
          ),
        ),
        // Core circle with glyph
        Container(
          width: 72,
          height: 72,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: const LinearGradient(
              colors: [
                UiConstants.primaryButtonColor,
                UiConstants.primaryDark,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: UiConstants.primaryButtonColor.withValues(alpha: 0.45),
                blurRadius: 32,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          alignment: Alignment.center,
          child: const Text(
            '</>',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w900,
              letterSpacing: -0.5,
            ),
          ),
        ),
      ],
    );
  }
}

// ── Feature pills row ─────────────────────────────────────────────────────────

class _FeaturePills extends StatelessWidget {
  static const _items = [
    (Icons.bolt_rounded, 'Daily Problems'),
    (Icons.emoji_events_rounded, 'Contests'),
    (Icons.trending_up_rounded, 'Track Progress'),
  ];

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (int i = 0; i < _items.length; i++) ...[
          _Pill(icon: _items[i].$1, label: _items[i].$2),
          if (i < _items.length - 1) const SizedBox(width: 8),
        ],
      ],
    );
  }
}

class _Pill extends StatelessWidget {
  final IconData icon;
  final String label;
  const _Pill({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: UiConstants.primaryButtonColor.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(AppDimens.rPill),
        border: Border.all(
          color: UiConstants.primaryButtonColor.withValues(alpha: 0.22),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: UiConstants.primaryButtonColor),
          const SizedBox(width: 5),
          Text(
            label,
            style: const TextStyle(
              color: UiConstants.primaryButtonColor,
              fontSize: 11,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
