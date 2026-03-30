import 'dart:io';

void main() {
  final file = File('lib/future/learning/presentation/pages/roadmap_paths_page.dart');
  String content = file.readAsStringSync();
  
  content = content.replaceFirst(
    '''
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 10 * sc, vertical: 4 * sc),
                                decoration: BoxDecoration(
                                  color: UiConstants.primaryButtonColor.withValues(alpha: 0.2),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  path.difficultyLevel,
                                  style: TextStyle(
                                    color: UiConstants.primaryButtonColor,
                                    fontSize: 11 * sc,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 10 * sc),
                          Text(
                            path.title,
                            style: TextStyle(
                              color: UiConstants.mainTextColor,
                              fontSize: 17 * sc,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          SizedBox(height: 6 * sc),
                          Text(
                            path.description,
                            style: TextStyle(color: UiConstants.subtitleTextColor, fontSize: 12 * sc, height: 1.35),
                          ),
''',
    '''
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      padding: EdgeInsets.symmetric(horizontal: 10 * sc, vertical: 4 * sc),
                                      decoration: BoxDecoration(
                                        color: UiConstants.primaryButtonColor.withValues(alpha: 0.2),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Text(
                                        path.difficultyLevel,
                                        style: TextStyle(
                                          color: UiConstants.primaryButtonColor,
                                          fontSize: 11 * sc,
                                          fontWeight: FontWeight.w800,
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 10 * sc),
                                    Text(
                                      path.title,
                                      style: TextStyle(
                                        color: UiConstants.mainTextColor,
                                        fontSize: 17 * sc,
                                        fontWeight: FontWeight.w900,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.all(8 * sc),
                                decoration: BoxDecoration(
                                  color: Colors.white10,
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.chevron_right_rounded,
                                  color: UiConstants.primaryButtonColor,
                                  size: 20 * sc,
                                )
                              )
                            ],
                          ),
                          SizedBox(height: 8 * sc),
                          Text(
                            path.description,
                            style: TextStyle(color: UiConstants.subtitleTextColor, fontSize: 13 * sc, height: 1.4),
                          ),
'''
  );
  
  file.writeAsStringSync(content);
}
