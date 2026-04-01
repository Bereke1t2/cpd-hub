import 'dart:io';

void main() {
  final file = File('lib/future/learning/presentation/pages/learning_hub_page.dart');
  var content = file.readAsStringSync();
  content = content.replaceAll(
    'decoration: BoxDecoration(\n            color: UiConstants.primaryButtonColor.withValues(alpha: 0.05),\n            borderRadius: BorderRadius.circular(20),',
    'decoration: BoxDecoration(\n            color: UiConstants.primaryButtonColor.withValues(alpha: 0.05),\n            borderRadius: BorderRadius.circular(20),'
  );
  file.writeAsStringSync(content);
}
