// lib/core/widgets/app_text.dart
//
// Phase 13 — typed text widget. Every font size flows through here so
// no feature widget hard-codes a fontSize. Scales via context.r.sp()
// to respect device density + clamped OS text-scale.

import 'package:flutter/material.dart';
import 'package:lab_portal/core/theme/app_dimens.dart';
import 'package:lab_portal/core/theme/app_text_styles.dart';
import 'package:lab_portal/core/theme/responsive.dart';

class AppText extends StatelessWidget {
  final String data;
  final TextStyle _base;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;
  final Color? color;
  final FontWeight? fontWeight;

  AppText._(
    this.data,
    this._base, {
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.color,
    this.fontWeight,
    super.key,
  });

  factory AppText.hero(String data, {Color? color, TextAlign? textAlign, Key? key}) =>
      AppText._(data, AppTextStyles.hero, color: color, textAlign: textAlign, key: key);

  factory AppText.h1(String data, {Color? color, int? maxLines, TextOverflow? overflow, Key? key}) =>
      AppText._(data, AppTextStyles.h1, color: color, maxLines: maxLines, overflow: overflow, key: key);

  factory AppText.h2(String data, {Color? color, int? maxLines, TextOverflow? overflow, Key? key}) =>
      AppText._(data, AppTextStyles.h2, color: color, maxLines: maxLines, overflow: overflow, key: key);

  factory AppText.title(String data,
          {Color? color, int? maxLines, TextOverflow? overflow, FontWeight? fontWeight, Key? key}) =>
      AppText._(data, AppTextStyles.title,
          color: color, maxLines: maxLines, overflow: overflow, fontWeight: fontWeight, key: key);

  factory AppText.body(String data,
          {Color? color, int? maxLines, TextOverflow? overflow, TextAlign? textAlign, Key? key}) =>
      AppText._(data, AppTextStyles.body,
          color: color, maxLines: maxLines, overflow: overflow, textAlign: textAlign, key: key);

  factory AppText.caption(String data, {Color? color, int? maxLines, TextOverflow? overflow, Key? key}) =>
      AppText._(data, AppTextStyles.caption, color: color, maxLines: maxLines, overflow: overflow, key: key);

  factory AppText.micro(String data, {Color? color, Key? key}) =>
      AppText._(data, AppTextStyles.micro, color: color, key: key);

  @override
  Widget build(BuildContext context) {
    final base = _base.fontSize ?? AppDimens.fBody;
    return Text(
      data,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
      style: _base.copyWith(
        fontSize: context.r.sp(base),
        color: color ?? _base.color,
        fontWeight: fontWeight ?? _base.fontWeight,
      ),
    );
  }
}
