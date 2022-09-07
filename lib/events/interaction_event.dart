import 'package:dart_runner_bot/commands/commands.dart';
import 'package:dart_runner_bot/services/custom_message_builder.dart';
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

      if (msgText.startsWith('ping')) {
        event.message.channel.sendMessage(
          CustomMessageBuilder.build(
              authorName: 'Ping • Dart Runner Bot', title: 'Pong! I\'m up.')
            ..replyBuilder = ReplyBuilder.fromMessage(event.message),
        );
      }

      if (msgText.startsWith('help')) {
        List<EmbedFieldBuilder> helpFields = <EmbedFieldBuilder>[
          EmbedFieldBuilder(
            'Dart Runner Commands',
            '• `${EnvLoader.prefix}run`',
          ),
          EmbedFieldBuilder(
            'Get Help',
            'Run `command help` for more info\nLike, `${EnvLoader.prefix}run help`\n\nMore commands coming soon\nHelp me out by contributing to my GitHub repo',
          ),
        ];

        event.message.channel.sendMessage(
          CustomMessageBuilder.build(
            title: 'Hi! I\'m the `Dart Runner Bot`',
            description:
                'Hit me up if you want to execute some dart code right here on Discord.',
            fields: helpFields,
            authorName: 'Help • Dart Runner Bot',
          )..replyBuilder = ReplyBuilder.fromMessage(event.message),
        );
      }

      // Check if message content equals "run"
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
