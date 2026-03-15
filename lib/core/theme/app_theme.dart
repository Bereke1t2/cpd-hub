import 'package:flutter/material.dart';

enum AppThemeSize { small, normal, large }

class AppTheme {
  final AppThemeSize size;

  const AppTheme({this.size = AppThemeSize.normal});

  double get scale {
    switch (size) {
      case AppThemeSize.small:
        return 0.82;
      case AppThemeSize.normal:
        return 0.93;
      case AppThemeSize.large:
        return 1.08;
    }
  }

  // Typography (Material Design 3 baselines)
  double get fontSizeLabelSmall => 11.0 * scale;
  double get fontSizeLabelMedium => 12.0 * scale;
  double get fontSizeLabelLarge => 14.0 * scale;

  double get fontSizeBodySmall => 12.0 * scale;
  double get fontSizeBodyMedium => 14.0 * scale;
  double get fontSizeBodyLarge => 16.0 * scale;

  double get fontSizeTitleSmall => 14.0 * scale;
  double get fontSizeTitleMedium => 16.0 * scale;
  double get fontSizeTitleLarge => 22.0 * scale;

  double get fontSizeHeadlineSmall => 24.0 * scale;
  double get fontSizeHeadlineMedium => 28.0 * scale;
  double get fontSizeHeadlineLarge => 32.0 * scale;

  double get fontSizeDisplaySmall => 36.0 * scale;
  double get fontSizeDisplayMedium => 45.0 * scale;
  double get fontSizeDisplayLarge => 57.0 * scale;

  // Icon Sizes
  double get iconSizeSmall => 16.0 * scale;
  double get iconSizeNormal => 24.0 * scale;
  double get iconSizeLarge => 32.0 * scale;
  double get iconSizeExtraLarge => 48.0 * scale;

  // Spacing
  double get spacingExtraSmall => 4.0 * scale;
  double get spacingSmall => 8.0 * scale;
  double get spacingMedium => 16.0 * scale;
  double get spacingLarge => 24.0 * scale;
  double get spacingExtraLarge => 32.0 * scale;

  // Interactive targets (Material minimum is 48x48)
  double get buttonHeight => 48.0 * scale;
  double get buttonWidth => 150.0 * scale;
  double get minimumTouchTarget => 48.0 * scale;

  ThemeData get themeData {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: Colors.black,
      textTheme: TextTheme(
        labelSmall: TextStyle(fontSize: fontSizeLabelSmall),
        labelMedium: TextStyle(fontSize: fontSizeLabelMedium),
        labelLarge: TextStyle(fontSize: fontSizeLabelLarge),
        bodySmall: TextStyle(fontSize: fontSizeBodySmall),
        bodyMedium: TextStyle(fontSize: fontSizeBodyMedium),
        bodyLarge: TextStyle(fontSize: fontSizeBodyLarge),
        titleSmall: TextStyle(fontSize: fontSizeTitleSmall),
        titleMedium: TextStyle(fontSize: fontSizeTitleMedium),
        titleLarge: TextStyle(fontSize: fontSizeTitleLarge),
        headlineSmall: TextStyle(fontSize: fontSizeHeadlineSmall),
        headlineMedium: TextStyle(fontSize: fontSizeHeadlineMedium),
        headlineLarge: TextStyle(fontSize: fontSizeHeadlineLarge),
        displaySmall: TextStyle(fontSize: fontSizeDisplaySmall),
        displayMedium: TextStyle(fontSize: fontSizeDisplayMedium),
        displayLarge: TextStyle(fontSize: fontSizeDisplayLarge),
      ),
      iconTheme: IconThemeData(size: iconSizeNormal),
      appBarTheme: AppBarTheme(
        iconTheme: IconThemeData(size: iconSizeNormal),
        titleTextStyle: TextStyle(fontSize: fontSizeTitleLarge),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          minimumSize: Size(buttonWidth, buttonHeight),
          textStyle: TextStyle(fontSize: fontSizeLabelLarge),
        ),
      ),
    );
  }
}
