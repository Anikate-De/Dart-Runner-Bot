import 'dart:io';

class Commands {
  static Future<String> runCode(String code) async {
    final filename = 'temp/script.dart';

    await File(filename).writeAsString(code);

    var process = await Process.run('dart', [filename]);

    return process.stdout + process.stderr;
  }
}
