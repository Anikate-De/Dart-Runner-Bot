import 'dart:io';

import 'package:dart_runner_bot/models/code_output.dart';
import 'package:dart_runner_bot/services/custom_message_builder.dart';
import 'package:nyxx/nyxx.dart';
import 'package:nyxx_interactions/nyxx_interactions.dart';

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

  static Future<ComponentMessageBuilder> helpSpecific(List<String> args) async {
    String command = args.elementAt(0);
    switch (command) {
      case 'run':
        return CustomMessageBuilder.build(
            authorName: 'Run • Help',
            title: 'Run',
            description:
                'Attach your Dart (pure) code and get the output instantly',
            fields: [
              EmbedFieldBuilder(
                'How to use',
                'Paste your code inside triple backticks (\\`)\nLike,\ndart!run \\`\\`\\`\n```dart\nvoid main() {\n\tprint("Hello Bot");\n}```\\`\\`\\`',
              )
            ]);
      default:
        return CustomMessageBuilder.build(
          authorName: 'Help',
          title: 'FOUR-o-FOUR',
          description:
              'Looks like there\'s no command called `$command`\nRun `dart!help` to find the list of available commands',
        );
    }
  }
}
