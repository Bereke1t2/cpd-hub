import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

enum AppLogoVariant { mark, full }

class AppLogo extends StatelessWidget {
  final double size;
  final AppLogoVariant variant;

  const AppLogo({
    super.key,
    required this.size,
    this.variant = AppLogoVariant.mark,
  });

  @override
  Widget build(BuildContext context) {
    if (variant == AppLogoVariant.full) {
      return SvgPicture.asset(
        'assets/images/logo_full.svg',
        width: size,
      );
    }
    return SvgPicture.asset(
      'assets/images/logo_mark.svg',
      width: size,
      height: size,
    );
  }
}
