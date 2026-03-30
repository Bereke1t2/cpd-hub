import 'dart:io';

void main() {
  final file = File('lib/future/learning/presentation/pages/learning_hub_page.dart');
  String content = file.readAsStringSync();

  final oldCard = '''
  Widget _buildProblemsCard(BuildContext context, double sc) {
    return InkWell(
      onTap: () => Navigator.push(context, MaterialPageRoute<void>(builder: (_) => const ProblemsPage())),
      borderRadius: BorderRadius.circular(20),
      child: Ink(
        padding: EdgeInsets.all(16 * sc),
        decoration: BoxDecoration(
          color: UiConstants.infoBackgroundColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: UiConstants.primaryButtonColor.withValues(alpha: 0.3)),
          boxShadow: [
            BoxShadow(
              color: UiConstants.primaryButtonColor.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(12 * sc),
              decoration: BoxDecoration(
                color: UiConstants.primaryButtonColor.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(Icons.code_rounded, color: UiConstants.primaryButtonColor, size: 28 * sc),
            ),
            SizedBox(width: 16 * sc),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Practice Problems',
                    style: TextStyle(
                      color: UiConstants.mainTextColor,
                      fontSize: 16 * sc,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4 * sc),
                  Text(
                    'Access CP problems and past contests',
                    style: TextStyle(
                      color: UiConstants.subtitleTextColor,
                      fontSize: 13 * sc,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right_rounded, color: UiConstants.subtitleTextColor),
          ],
        ),
      ),
    );
  }
''';

  final newCard = '''
  Widget _buildProblemsCard(BuildContext context, double sc) {
    return InkWell(
      onTap: () => Navigator.push(context, MaterialPageRoute<void>(builder: (_) => const ProblemsPage())),
      borderRadius: BorderRadius.circular(20),
      child: Ink(
        padding: EdgeInsets.all(16 * sc),
        decoration: BoxDecoration(
          color: UiConstants.primaryButtonColor,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: UiConstants.primaryButtonColor.withValues(alpha: 0.3),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
          gradient: LinearGradient(
            colors: [
              UiConstants.primaryButtonColor.withValues(alpha: 0.9),
              UiConstants.primaryButtonColor.withValues(alpha: 0.4),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(12 * sc),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(Icons.code_rounded, color: Colors.white, size: 28 * sc),
            ),
            SizedBox(width: 16 * sc),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Practice Problems',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16 * sc,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4 * sc),
                  Text(
                    'Access CP problems and past contests',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.9),
                      fontSize: 13 * sc,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right_rounded, color: Colors.white),
          ],
        ),
      ),
    );
  }
''';

  if (content.contains(oldCard.trim())) {
    content = content.replaceFirst(oldCard.trim(), newCard.trim());
    file.writeAsStringSync(content);
    print("Success");
  } else {
    // try line by line matching or regex if exact doesn't work
    print("Failed to match exactly");
  }
}
