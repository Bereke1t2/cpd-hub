// lib/core/widgets/avatar.dart
//
// Phase 13 — replaces CircleAvatar(radius: 30) magic numbers.
// Sizes flow through AppDimens.avatar* (18 / 22 / 32).

import 'package:flutter/material.dart';
import 'package:lab_portal/core/theme/app_dimens.dart';
import 'package:lab_portal/core/ui_constants.dart';

class Avatar extends StatelessWidget {
  final String initials;
  final String? imageUrl;
  final Color? color;

  /// Radius in logical pixels. Use AppDimens.avatarSm/Md/Lg.
  final double size;

  const Avatar({
    super.key,
    required this.initials,
    this.imageUrl,
    this.color,
    this.size = AppDimens.avatarMd,
  });

  @override
  Widget build(BuildContext context) {
    final c = color ?? UiConstants.primaryButtonColor;
    // Only attach an image (and its error handler) when there's a real URL.
    // CircleAvatar asserts that onForegroundImageError is null without an image,
    // so an empty string must be treated the same as null.
    final hasImage = imageUrl != null && imageUrl!.isNotEmpty;
    return CircleAvatar(
      radius: size,
      backgroundColor: c.withValues(alpha: 0.15),
      foregroundImage: hasImage ? NetworkImage(imageUrl!) : null,
      onForegroundImageError: hasImage ? (_, __) {} : null,
      child: Text(
        initials,
        style: TextStyle(
          color: c,
          fontWeight: FontWeight.w700,
          fontSize: size * 0.6,
        ),
      ),
    );
  }
}
