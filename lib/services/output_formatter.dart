import 'package:dart_runner_bot/utils/ansi_color_prefix.dart';

class OutputFormatter {
  static String formatError(String errorString) {
    String formattedError = '';

    for (var line in errorString.split('\n')) {
      String prefix = AnsiColorPrefix.yellow;

      if (line.startsWith('#')) {
        if (line.contains('temp/script.dart:')) {
          prefix = AnsiColorPrefix.white;
        } else {
          prefix = AnsiColorPrefix.boldBlack;
        }
      }

      line = prefix + line;

      formattedError += '$line\n';
    }

    return formattedError;
  }
}
