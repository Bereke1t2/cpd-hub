import 'dart:io';

void main() {
  final file = File('lib/future/learning/presentation/pages/roadmap_timeline_page.dart');
  String content = file.readAsStringSync();
  
  content = content.replaceAll(
    '''
              child: Material(
                color: UiConstants.infoBackgroundColor,
                borderRadius: BorderRadius.circular(18),
''',
    '''
              child: Material(
                color: Colors.white10.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(24),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                  side: BorderSide(color: Colors.white24, width: 1.5),
                ),
'''
  );
  content = content.replaceAll('borderRadius: BorderRadius.circular(18),', 'borderRadius: BorderRadius.circular(24),');
  
  file.writeAsStringSync(content);
}
