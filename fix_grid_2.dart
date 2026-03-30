import 'dart:io';

void main() {
  final file = File('lib/future/learning/presentation/pages/learning_hub_page.dart');
  String content = file.readAsStringSync();
  
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
    '''color: UiConstants.primaryButtonColor,
          gradient: LinearGradient(
            colors: [
              UiConstants.primaryButtonColor.withValues(alpha: 0.8),
              UiConstants.primaryButtonColor.withValues(alpha: 0.4),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),'''
  );

  file.writeAsStringSync(content);
  print('updated grid cards');
}
