import 'package:dart_runner_bot/commands/commands.dart';
import 'package:dart_runner_bot/services/env_loader.dart';
import 'package:dart_runner_bot/services/output_formatter.dart';
import 'package:nyxx/nyxx.dart';

class InteractionEvent {
  static Future<void> onMessageReceived(INyxxWebsocket client) async {
    client.eventsWs.onMessageReceived.listen((event) {
      String msgText = event.message.content;

      /// This makes your bot ignore other bots and itself
      /// and not get into a spam loop (we call that "botception").
      if (event.message.author.bot) return;

      if (!msgText.startsWith(EnvLoader.prefix)) return;

      msgText = msgText.substring(EnvLoader.prefix.length);

      // Check if message content equals "!run"
      if (msgText.startsWith('run')) {
        // Extract the dart code, present within '```'
        final startIndex = msgText.indexOf('```');
        final endIndex = msgText.indexOf('```', startIndex + 3);

        // Call the runCode function to execute code and send the returned value as a message
        String code = msgText.substring(startIndex + 3, endIndex).trim();
        Commands.runCode(code).then((value) {
          event.message.channel.sendMessage(MessageBuilder.content(
              '```ansi\n${value.outputMessage + OutputFormatter.formatError(value.errorMessage)}```\nExited (${value.exitCode})')
            ..replyBuilder = ReplyBuilder.fromMessage(event.message));
        });
      }
    });
  }
}
