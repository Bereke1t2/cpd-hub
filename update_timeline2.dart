import 'dart:io';

void main() {
  final file = File('lib/future/learning/presentation/pages/roadmap_timeline_page.dart');
  String content = file.readAsStringSync();
  
  content = content.replaceFirst(
    '''
                        Row(
                          children: [
                            Icon(Icons.article_outlined, size: 14 * sc, color: UiConstants.primaryButtonColor),
                            SizedBox(width: 6 * sc),
                            Text('Quick read', style: TextStyle(color: UiConstants.primaryButtonColor, fontSize: 11 * sc)),
                            SizedBox(width: 14 * sc),
                            if (module.videoUrl != null) ...[
                              Icon(Icons.play_circle_outline_rounded, size: 14 * sc, color: Colors.redAccent),
                              SizedBox(width: 6 * sc),
                              Text('Watch', style: TextStyle(color: Colors.redAccent, fontSize: 11 * sc)),
                            ],
                          ],
                        ),
                        SizedBox(height: 8 * sc),
                        Text(
                          '\${module.linkedProblems.length} practice problems',
                          style: TextStyle(
                            color: UiConstants.subtitleTextColor.withValues(alpha: 0.7),
                            fontSize: 11 * sc,
                          ),
                        ),
''',
    '''
                        SizedBox(height: 12 * sc),
                        Wrap(
                          spacing: 8 * sc,
                          runSpacing: 8 * sc,
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 8 * sc, vertical: 4 * sc),
                              decoration: BoxDecoration(
                                color: UiConstants.primaryButtonColor.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(color: UiConstants.primaryButtonColor.withValues(alpha: 0.3)),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.article_outlined, size: 14 * sc, color: UiConstants.primaryButtonColor),
                                  SizedBox(width: 6 * sc),
                                  Text('Quick read', style: TextStyle(color: UiConstants.primaryButtonColor, fontSize: 11 * sc, fontWeight: FontWeight.w600)),
                                ],
                              ),
                            ),
                            if (module.videoUrl != null)
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 8 * sc, vertical: 4 * sc),
                                decoration: BoxDecoration(
                                  color: Colors.redAccent.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(6),
                                  border: Border.all(color: Colors.redAccent.withValues(alpha: 0.3)),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.play_circle_outline_rounded, size: 14 * sc, color: Colors.redAccent),
                                    SizedBox(width: 6 * sc),
                                    Text('Watch', style: TextStyle(color: Colors.redAccent, fontSize: 11 * sc, fontWeight: FontWeight.w600)),
                                  ],
                                ),
                              ),
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 8 * sc, vertical: 4 * sc),
                              decoration: BoxDecoration(
                                color: Colors.white10,
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(color: Colors.white24),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.code_rounded, size: 14 * sc, color: UiConstants.subtitleTextColor),
                                  SizedBox(width: 6 * sc),
                                  Text(
                                    '\${module.linkedProblems.length} problems',
                                    style: TextStyle(color: UiConstants.subtitleTextColor, fontSize: 11 * sc, fontWeight: FontWeight.w600),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
'''
  );
  
  file.writeAsStringSync(content);
}
