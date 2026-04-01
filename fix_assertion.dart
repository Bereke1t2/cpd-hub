import 'dart:io';

void main() {
  final file = File('lib/future/learning/presentation/pages/learning_hub_page.dart');
  var content = file.readAsStringSync();
  content = content.replaceAll(
    'return Material(\n      color: Colors.transparent,\n      borderRadius: BorderRadius.circular(20),\n      child: InkWell(\n        borderRadius: BorderRadius.circular(20),\n        onTap: onTap,\n        child: Ink(\n          decoration: BoxDecoration(\n            color: UiConstants.primaryButtonColor.withValues(alpha: 0.05),\n            borderRadius: BorderRadius.circular(20),',
    'return Material(\n      color: Colors.transparent,\n      borderRadius: BorderRadius.circular(20),\n      clipBehavior: Clip.antiAlias,\n      child: InkWell(\n        borderRadius: BorderRadius.circular(20),\n        onTap: onTap,\n        child: Ink(\n          decoration: BoxDecoration(\n            color: UiConstants.primaryButtonColor.withValues(alpha: 0.05),\n            borderRadius: BorderRadius.circular(20),'
  );
  file.writeAsStringSync(content);
}
