import 'package:flutter/material.dart';

import '../../../../core/ui_constants.dart';

class BarBox extends StatelessWidget {
  final String text;
  final bool isSelected;
  final VoidCallback? onTap;
  const BarBox({
    super.key,
    required this.text,
    required this.isSelected,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected
              ? UiConstants.primaryButtonColor.withOpacity(0.92)
              : UiConstants.infoBackgroundColor,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(
            color: isSelected
                ? UiConstants.primaryButtonColor.withOpacity(0.55)
                : UiConstants.primaryButtonColor.withOpacity(0.18),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.10),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: isSelected
                ? Colors.white.withValues(alpha: 0.92)
                : Colors.white.withValues(alpha: 0.82),
          ),
        ),
      ),
    );
  }
}