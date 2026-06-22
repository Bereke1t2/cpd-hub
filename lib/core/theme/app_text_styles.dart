import 'package:flutter/material.dart';
import 'package:lab_portal/core/theme/app_dimens.dart';
import 'package:lab_portal/core/ui_constants.dart';

/// Named text styles. Replace inline TextStyle(fontSize: …) usages with these.
/// Base sizes come from AppDimens.f*. For device-adaptive sizing, scale at the
/// call site: TextStyle(fontSize: context.r.sp(AppDimens.fBody)).
class AppTextStyles {
  AppTextStyles._();

  static const TextStyle hero = TextStyle(
    fontSize: AppDimens.fHero,
    fontWeight: FontWeight.w700,
    color: UiConstants.mainTextColor,
  );

  static const TextStyle h1 = TextStyle(
    fontSize: AppDimens.fH1,
    fontWeight: FontWeight.w700,
    color: UiConstants.mainTextColor,
  );

  static const TextStyle h2 = TextStyle(
    fontSize: AppDimens.fH2,
    fontWeight: FontWeight.w600,
    color: UiConstants.mainTextColor,
  );

  static const TextStyle title = TextStyle(
    fontSize: AppDimens.fTitle,
    fontWeight: FontWeight.w600,
    color: UiConstants.mainTextColor,
  );

  static const TextStyle body = TextStyle(
    fontSize: AppDimens.fBody,
    color: UiConstants.mainTextColor,
  );

  static const TextStyle caption = TextStyle(
    fontSize: AppDimens.fCaption,
    color: UiConstants.subtitleTextColor,
  );

  static const TextStyle micro = TextStyle(
    fontSize: AppDimens.fMicro,
    color: UiConstants.subtitleTextColor,
  );

  static const TextStyle stat = TextStyle(
    fontSize: AppDimens.fTitle,
    fontWeight: FontWeight.w600,
    color: UiConstants.statTextColor,
  );
}
