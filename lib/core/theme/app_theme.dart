import 'package:flutter/material.dart';

enum AppThemeSize { small, normal, large }

class AppTheme {
  final AppThemeSize size;

  const AppTheme({this.size = AppThemeSize.normal});

  double get scale {
    switch (size) {
      case AppThemeSize.small:
        return 0.8;
      case AppThemeSize.normal:
        return 1.2;
      case AppThemeSize.large:
        return 1.8;
    }
  }

  // Common sizes dynamically scaled
  double get fontSizeSmall => 12.0 * scale;
  double get fontSizeNormal => 14.0 * scale;
  double get fontSizeLarge => 18.0 * scale;
  double get fontSizeTitle => 24.0 * scale;

  double get iconSizeSmall => 16.0 * scale;
  double get iconSizeNormal => 24.0 * scale;
  double get iconSizeLarge => 32.0 * scale;

  double get spacingSmall => 8.0 * scale;
  double get spacingNormal => 16.0 * scale;
  double get spacingLarge => 24.0 * scale;

  double get buttonHeight => 48.0 * scale;
  double get buttonWidth => 150.0 * scale;
  
  // Custom ThemeData
  ThemeData get themeData {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: Colors.black,
      textTheme: TextTheme(
        bodySmall: TextStyle(fontSize: fontSizeSmall),
        bodyMedium: TextStyle(fontSize: fontSizeNormal),
        bodyLarge: TextStyle(fontSize: fontSizeLarge),
        titleLarge: TextStyle(fontSize: fontSizeTitle),
        titleMedium: TextStyle(fontSize: fontSizeLarge),
      ),
      iconTheme: IconThemeData(size: iconSizeNormal),
    );
  }
}
