import 'dart:io';

void main() {
  final file = File('lib/future/learning/presentation/pages/module_detail_page.dart');
  String content = file.readAsStringSync();

  content = content.replaceAll(
    '''
    return Scaffold(
      backgroundColor: UiConstants.infoBackgroundColor.withValues(alpha: 0.9),''',
    '''
    return Scaffold(
      backgroundColor: UiConstants.backgroundColor,''');
      
  content = content.replaceAll(
    '''
              Material(
                color: UiConstants.infoBackgroundColor,
                borderRadius: BorderRadius.circular(16),
                child: InkWell(
                  borderRadius: BorderRadius.circular(16),
''',
    '''
              Material(
                color: UiConstants.primaryButtonColor.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(16),
                child: InkWell(
                  borderRadius: BorderRadius.circular(16),
''');

  content = content.replaceAll(
    '''
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: UiConstants.borderColor.withValues(alpha: 0.15)),
                    ),''',
    '''
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: UiConstants.primaryButtonColor.withValues(alpha: 0.3)),
                    ),''');

  content = content.replaceAll(
    '''
                              Text(
                                '\${p.difficulty} · IDs sync with API later',
                                style: TextStyle(color: UiConstants.subtitleTextColor, fontSize: 11 * sc),
                              ),''',
    '''
                              Text(
                                p.difficulty,
                                style: TextStyle(
                                  color: UiConstants.primaryButtonColor.withValues(alpha: 0.9), 
                                  fontSize: 12 * sc,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),''');

  content = content.replaceAll(
    '''
                          ? Image.network(
                              'https://img.youtube.com/vi/\$yt/hqdefault.jpg',
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => Container(
                                color: Colors.black26,
                                child: Icon(Icons.play_circle_filled_rounded, size: 56 * sc, color: Colors.white70),
                              ),
                            )''',
    '''
                          ? Stack(
                              fit: StackFit.expand,
                              children: [
                                Image.network(
                                  'https://img.youtube.com/vi/\$yt/hqdefault.jpg',
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) => Container(
                                    color: UiConstants.primaryButtonColor.withValues(alpha: 0.1),
                                  ),
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        Colors.black.withValues(alpha: 0.4),
                                        Colors.transparent,
                                        Colors.black.withValues(alpha: 0.6),
                                      ],
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                    ),
                                  ),
                                ),
                              ],
                            )''');
                            
  content = content.replaceAll(
    '''
                    Icon(Icons.play_circle_fill_rounded, size: 64 * sc, color: Colors.white.withValues(alpha: 0.9)),''',
    '''
                    Container(
                      padding: EdgeInsets.all(8 * sc),
                      decoration: BoxDecoration(
                        color: UiConstants.primaryButtonColor.withValues(alpha: 0.8),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: UiConstants.primaryButtonColor.withValues(alpha: 0.4),
                            blurRadius: 12,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: Icon(Icons.play_arrow_rounded, size: 48 * sc, color: Colors.white),
                    ),''');

  content = content.replaceAll(
    '''Text('Watch', style: TextStyle(color: UiConstants.subtitleTextColor, fontSize: 12 * sc, fontWeight: FontWeight.w700)),''',
    '''Text('VIDEO LECTURE', style: TextStyle(color: UiConstants.primaryButtonColor, fontSize: 12 * sc, letterSpacing: 1.2, fontWeight: FontWeight.bold)),''');
    
  content = content.replaceAll(
    '''
          Text(
            'Quick read',
            style: TextStyle(color: UiConstants.subtitleTextColor, fontSize: 12 * sc, fontWeight: FontWeight.w700),
          ),''',
    '''
          Container(
            padding: EdgeInsets.all(16 * sc),
            decoration: BoxDecoration(
              color: UiConstants.infoBackgroundColor,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: UiConstants.borderColor.withValues(alpha: 0.1)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'LESSON NOTES',
                  style: TextStyle(color: UiConstants.primaryButtonColor, fontSize: 12 * sc, letterSpacing: 1.2, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 12 * sc),''');

  // Need to close the container we just opened around markdown
  content = content.replaceAll(
    '''          SizedBox(height: 24 * sc),
          Text(
            'Practice',
            style: TextStyle(color: UiConstants.subtitleTextColor, fontSize: 12 * sc, fontWeight: FontWeight.w700),
          ),''',
    '''              ],
            ),
          ),
          SizedBox(height: 24 * sc),
          Text(
            'PRACTICE PROBLEMS',
            style: TextStyle(color: UiConstants.primaryButtonColor, fontSize: 12 * sc, letterSpacing: 1.2, fontWeight: FontWeight.bold),
          ),''');

  file.writeAsStringSync(content);
  print('updated module details');
}
