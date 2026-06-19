import 'package:flutter/material.dart';
import 'package:lab_portal/core/ui_constants.dart';

/// Named text styles. Replace inline TextStyle(fontSize: …) usages with these.
class AppTextStyles {
  AppTextStyles._();

  static const TextStyle h1 = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w700,
    color: UiConstants.mainTextColor,
  );

  static const TextStyle h2 = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: UiConstants.mainTextColor,
  );

  static const TextStyle title = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: UiConstants.mainTextColor,
  );

  static const TextStyle body = TextStyle(
    fontSize: 14,
    color: UiConstants.mainTextColor,
  );

  static const TextStyle caption = TextStyle(
    fontSize: 12,
    color: UiConstants.subtitleTextColor,
  );

  static const TextStyle stat = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: UiConstants.statTextColor,
  );
}
