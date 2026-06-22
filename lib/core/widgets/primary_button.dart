// lib/core/widgets/primary_button.dart
//
// Phase 13 — replaces NormalButtons (width: 180) and BigButton (fontSize: 20).
// 46px tall, full-width by default, routes through AppDimens.

import 'package:flutter/material.dart';
import 'package:lab_portal/core/theme/app_dimens.dart';
import 'package:lab_portal/core/ui_constants.dart';

class PrimaryButton extends StatelessWidget {
  final String title;
  final VoidCallback? onPressed;
  final bool fullWidth;
  final IconData? icon;
  final Color? color;

  const PrimaryButton({
    super.key,
    required this.title,
    this.onPressed,
    this.fullWidth = true,
    this.icon,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final bg = color ?? UiConstants.primaryButtonColor;
    final btn = SizedBox(
      width: fullWidth ? double.infinity : null,
      height: AppDimens.buttonHeight,
      child: FilledButton(
        onPressed: onPressed,
        style: FilledButton.styleFrom(
          backgroundColor: bg,
          foregroundColor: UiConstants.mainTextColor,
          shape: const RoundedRectangleBorder(borderRadius: AppDimens.brMd),
          padding: const EdgeInsets.symmetric(horizontal: AppDimens.lg),
        ),
        child: icon != null
            ? Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(icon, size: AppDimens.iconSm),
                  const SizedBox(width: AppDimens.sm),
                  Text(title,
                      style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: AppDimens.fTitle)),
                ],
              )
            : Text(title,
                style: const TextStyle(
                    fontWeight: FontWeight.w700, fontSize: AppDimens.fTitle)),
      ),
    );
    if (fullWidth) return btn;
    return btn;
  }
}
