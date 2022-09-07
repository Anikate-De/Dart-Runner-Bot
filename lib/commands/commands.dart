import 'dart:io';

import 'package:dart_runner_bot/models/code_output.dart';

class Commands {
  static Future<CodeOutput> runCode(String code) async {
    final filename = 'temp/script.dart';

    await File(filename).writeAsString(code);

    var process = await Process.run('dart', [filename]);
    return CodeOutput(
        outputMessage: process.stdout,
        errorMessage: process.stderr,
        exitCode: process.exitCode);
  }
}
