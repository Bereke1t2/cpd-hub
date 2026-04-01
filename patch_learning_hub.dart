import 'dart:io';

void main() {
  final file = File('lib/future/learning/presentation/pages/learning_hub_page.dart');
  String content = file.readAsStringSync();
  
  // Replace the buildGridCard calls to add gradientColors
  content = content.replaceAll(
    "imageUrl: 'assets/images/radar_bg.png', // Background image slot",
    "imageUrl: 'assets/images/radar_bg.png', gradientColors: [Color(0xFF6A1B9A), Color(0xFF4A148C)],"
  );
  content = content.replaceAll(
    "imageUrl: 'assets/images/calendar_bg.png', // Background image slot",
    "imageUrl: 'assets/images/calendar_bg.png', gradientColors: [Color(0xFF1565C0), Color(0xFF0D47A1)],"
  );
  content = content.replaceAll(
    "imageUrl: 'assets/images/templates_bg.png', // Background image slot",
    "imageUrl: 'assets/images/templates_bg.png', gradientColors: [Color(0xFF00695C), Color(0xFF004D40)],"
  );
  content = content.replaceAll(
    "imageUrl: 'assets/images/challenge_bg.png', // Background image slot",
    "imageUrl: 'assets/images/challenge_bg.png', gradientColors: [Color(0xFFE65100), Color(0xFFBF360C)],"
  );

  content = content.replaceAll(
    "Required Color accentUrl,",
    "required Color accentUrl,\\n    List<Color>? gradientColors,"
  );

  content = content.replaceAll(
    "required VoidCallback onTap,\\n  }) {",
    "required VoidCallback onTap,\\n    List<Color>? gradientColors,\\n  }) {\\n    List<Color> colors = gradientColors ?? [\\n      UiConstants.secondaryButtonColor.withValues(alpha: 0.8),\\n      UiConstants.secondaryButtonColor.withValues(alpha: 0.4),\\n    ];"
  );
  
  content = content.replaceAll(
    "colors: [\\n                UiConstants.secondaryButtonColor.withValues(alpha: 0.8),\\n                UiConstants.secondaryButtonColor.withValues(alpha: 0.4),\\n              ],",
    "colors: colors,"
  );
  
  content = content.replaceAll(
    "color: UiConstants.secondaryButtonColor,",
    "color: colors.first," // Need to be careful here, only replacing the one inside gridCard
  );
  
  file.writeAsStringSync(content);
}
