import 'package:flutter/material.dart';
import 'package:cpd_hub/core/theme/theme_ext.dart';
import '../../../../core/ui_constants.dart';

class BarBox extends StatelessWidget {
  final String text;
  final IconData? icon;
  final bool isActive;

  const BarBox({
    super.key,
    required this.text,
    this.icon,
    this.isActive = false,
  });

  @override
  Widget build(BuildContext context) {
    final sc = context.sc;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      padding: EdgeInsets.symmetric(horizontal: 14 * sc, vertical: 8 * sc),
      decoration: BoxDecoration(
        color: isActive ? UiConstants.primaryButtonColor : Colors.white.withValues(alpha: 0.03),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isActive ? Colors.transparent : Colors.white10,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(
              icon,
              size: 14 * sc,
              color: isActive ? Colors.black : UiConstants.primaryButtonColor,
            ),
            SizedBox(width: 6 * sc),
          ],
          Text(
            text,
            style: TextStyle(
              fontSize: 12 * sc,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.3,
              color: isActive ? Colors.black : UiConstants.subtitleTextColor,
            ),
          ),
        ],
      ),
    );
  }
}
