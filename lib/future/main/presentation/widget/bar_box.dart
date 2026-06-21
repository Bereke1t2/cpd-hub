import 'package:flutter/material.dart';
import 'package:lab_portal/core/theme/app_dimens.dart';
import 'package:lab_portal/core/ui_constants.dart';

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
      borderRadius: const BorderRadius.all(Radius.circular(AppDimens.rPill)),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(
            horizontal: AppDimens.lg, vertical: AppDimens.sm),
        decoration: BoxDecoration(
          color: isSelected
              ? UiConstants.primaryButtonColor.withValues(alpha: 0.92)
              : UiConstants.infoBackgroundColor,
          borderRadius:
              const BorderRadius.all(Radius.circular(AppDimens.rPill)),
          border: Border.all(
            color: isSelected
                ? UiConstants.primaryButtonColor.withValues(alpha: 0.55)
                : UiConstants.primaryButtonColor.withValues(alpha: 0.18),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.10),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: AppDimens.fBody,
            fontWeight: FontWeight.w700,
            color: Colors.white.withValues(alpha: isSelected ? 0.92 : 0.82),
          ),
        ),
      ),
    );
  }
}
