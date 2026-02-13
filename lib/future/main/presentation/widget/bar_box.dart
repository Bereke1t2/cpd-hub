import 'package:flutter/material.dart';
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
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: isActive ? UiConstants.primaryButtonColor : UiConstants.infoBackgroundColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isActive ? UiConstants.primaryButtonColor : UiConstants.borderColor.withOpacity(0.3),
          width: 1.5,
        ),
        boxShadow: isActive ? [
          BoxShadow(
            color: UiConstants.primaryButtonColor.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          )
        ] : [],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(
              icon,
              size: 16,
              color: isActive ? Colors.black : UiConstants.primaryButtonColor,
            ),
            const SizedBox(width: 8),
          ],
          Text(
            text,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w900,
              letterSpacing: 0.5,
              color: isActive ? Colors.black : UiConstants.mainTextColor.withOpacity(0.8),
            ),
          ),
        ],
      ),
    );
  }
}