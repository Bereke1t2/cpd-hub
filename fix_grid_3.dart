import 'dart:io';

void main() {
  final file = File('lib/future/learning/presentation/pages/learning_hub_page.dart');
  String content = file.readAsStringSync();

  content = content.replaceAll(
    '''color: UiConstants.primaryButtonColor,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: UiConstants.borderColor.withValues(alpha: 0.1)),
            image: DecorationImage(
              image: AssetImage(imageUrl),
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(Colors.black.withValues(alpha: 0.5), BlendMode.dstATop),
            ),''',
    '''color: UiConstants.primaryButtonColor,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: UiConstants.borderColor.withValues(alpha: 0.1)),
            gradient: LinearGradient(
              colors: [
                UiConstants.primaryButtonColor.withValues(alpha: 0.8),
                UiConstants.primaryButtonColor.withValues(alpha: 0.4),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            image: DecorationImage(
              image: AssetImage(imageUrl),
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(Colors.black.withValues(alpha: 0.2), BlendMode.dstATop),
            ),'''
  );
  
  file.writeAsStringSync(content);
  print('updated grid again');
}
