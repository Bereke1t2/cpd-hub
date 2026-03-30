import 'dart:io';

void main() {
  final file = File('lib/future/learning/presentation/pages/roadmap_timeline_page.dart');
  String content = file.readAsStringSync();
  
  content = content.replaceFirst(
    '''
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                module.title,
                                style: TextStyle(
                                  color: UiConstants.mainTextColor,
                                  fontSize: 15 * sc,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                            IconButton(
                              onPressed: onToggleDone,
                              icon: Icon(
                                done ? Icons.undo_rounded : Icons.check_circle_outline_rounded,
                                color: done ? UiConstants.subtitleTextColor : UiConstants.primaryButtonColor,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          module.summaryLine,
                          style: TextStyle(color: UiConstants.subtitleTextColor, fontSize: 12 * sc),
                        ),
''',
    '''
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Text(
                                module.title,
                                style: TextStyle(
                                  color: UiConstants.mainTextColor,
                                  fontSize: 15 * sc,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                            IconButton(
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                              onPressed: onToggleDone,
                              icon: Icon(
                                done ? Icons.undo_rounded : Icons.check_circle_outline_rounded,
                                color: done ? UiConstants.subtitleTextColor : UiConstants.primaryButtonColor,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 4 * sc),
                        Text(
                          module.summaryLine,
                          style: TextStyle(color: UiConstants.subtitleTextColor, fontSize: 12 * sc),
                        ),
'''
  );
  
  file.writeAsStringSync(content);
}
