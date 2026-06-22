import 'package:flutter/material.dart';
import 'package:lab_portal/core/theme/app_dimens.dart';
import 'package:lab_portal/core/ui_constants.dart';
import 'package:lab_portal/core/widgets/app_chip.dart';

/// Thin wrapper kept for backward-compat. Prefer AppChip(tag) directly.
class TagBox extends StatelessWidget {
  final String tag;
  const TagBox({super.key, required this.tag});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: AppDimens.xs),
      child: AppChip(tag, color: UiConstants.secondaryButtonColor),
    );
  }
}
