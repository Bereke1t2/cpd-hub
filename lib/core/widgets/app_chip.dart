// lib/core/widgets/app_chip.dart
//
// Phase 13 — replaces all inline tag/badge/difficulty Containers.
// Always pairs color with a label (a11y: no color-only semantics).

import 'package:flutter/material.dart';
import 'package:lab_portal/core/theme/app_dimens.dart';
import 'package:lab_portal/core/ui_constants.dart';

class AppChip extends StatelessWidget {
  final String label;
  final Color? color;
  final Color? backgroundColor;
  final IconData? icon;

  const AppChip(
    this.label, {
    this.color,
    this.backgroundColor,
    this.icon,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final c = color ?? UiConstants.primaryButtonColor;
    final bg = backgroundColor ?? c.withValues(alpha: 0.12);
    return Container(
      height: AppDimens.chipHeight,
      padding: const EdgeInsets.symmetric(
          horizontal: AppDimens.sm, vertical: AppDimens.xs),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: const BorderRadius.all(Radius.circular(AppDimens.rPill)),
        border: Border.all(color: c.withValues(alpha: 0.30)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 12, color: c),
            const SizedBox(width: AppDimens.xxs),
          ],
          // Flexible + ellipsis so a chip never overflows its row when the
          // surrounding Wrap/Expanded squeezes it (e.g. high text scale on a
          // narrow card). At normal sizes there's ample room and nothing
          // truncates.
          Flexible(
            child: Text(
              label,
              maxLines: 1,
              softWrap: false,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: c,
                fontSize: AppDimens.fCaption,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
