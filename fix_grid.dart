import 'dart:io';

void main() {
  final file = File('lib/future/learning/presentation/pages/learning_hub_page.dart');
  String content = file.readAsStringSync();
  
  if (content.contains('UiConstants.infoBackgroundColor.withValues(alpha: 0.85)')) {
    content = content.replaceAll(
      'UiConstants.infoBackgroundColor.withValues(alpha: 0.85)',
      'Colors.black.withValues(alpha: 0.5)'
    );
     content = content.replaceAll(
      'color: UiConstants.mainTextColor,',
      'color: Colors.white,'
    );
    content = content.replaceAll(
      'color: UiConstants.subtitleTextColor,',
      'color: Colors.white.withValues(alpha: 0.9),'
    );
      content = content.replaceAll(
      'color: UiConstants.infoBackgroundColor,',
      'color: UiConstants.primaryButtonColor,'
    );
      
    file.writeAsStringSync(content);
    print("Success grid");
  } else {
    print("Fail grid");
  }
}
