import 'dart:io';

void main() {
  var dir = Directory('lib');
  var files = dir.listSync(recursive: true).whereType<File>().where((f) => f.path.endsWith('.dart'));
  
  for (var file in files) {
    try {
        var content = file.readAsStringSync();
        // check for shape: BoxShape.circle accompanied by borderRadius anywhere within same BoxDecoration
        // this is harder with regex, let's use a simpler heuristic for now
    } catch (e) {
    }
  }
}
