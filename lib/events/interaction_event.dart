import 'package:dart_runner_bot/commands/commands.dart';
import 'package:dart_runner_bot/services/custom_message_builder.dart';
import 'package:dart_runner_bot/services/env_loader.dart';
import 'package:dart_runner_bot/services/output_formatter.dart';
import 'package:nyxx/nyxx.dart';

class InteractionEvent {
  static Future<void> onMessageReceived(INyxxWebsocket client) async {
    client.eventsWs.onMessageReceived.listen((event) async {
      String msgText = event.message.content;

      /// This makes your bot ignore other bots and itself
      /// and not get into a spam loop (we call that "botception").
      if (event.message.author.bot) return;

      if (!msgText.startsWith(EnvLoader.prefix)) return;

      msgText = msgText.substring(EnvLoader.prefix.length);
      List<String> commandList = msgText.split(' ');
      var command = commandList.elementAt(0);
      var args = commandList.sublist(1);

      switch (command) {
        case 'ping':
          event.message.channel.sendMessage(
            CustomMessageBuilder.build(
                authorName: 'Ping', title: 'Pong! I\'m up.')
              ..replyBuilder = ReplyBuilder.fromMessage(event.message),
          );
          break;

        case 'help':
          if (args.isNotEmpty) {
            Commands.helpSpecific(args)
                .then((value) => event.message.channel.sendMessage(
                      value
                        ..replyBuilder =
                            ReplyBuilder.fromMessage(event.message),
                    ));
            return;
          }
          List<EmbedFieldBuilder> helpFields = <EmbedFieldBuilder>[
            EmbedFieldBuilder(
              'Dart Runner Commands',
              '• `${EnvLoader.prefix}run`',
            ),
            EmbedFieldBuilder(
              'Get Help',
              'Run `${EnvLoader.prefix}help <command>` for more info\nLike, `${EnvLoader.prefix}help run`\n\nMore commands coming soon\nHelp me out by contributing to my GitHub repo',
            ),
          ];

          event.message.channel.sendMessage(
            CustomMessageBuilder.build(
              title: 'Hi! I\'m the `Dart Runner Bot`',
              description:
                  'Hit me up if you want to execute some dart code right here on Discord.',
              fields: helpFields,
              authorName: 'Help',
            )..replyBuilder = ReplyBuilder.fromMessage(event.message),
          );
          break;

        case 'run':
          var rawCode = args.join();

          try {
            // Extract the dart code, present within '```'
            final startIndex = rawCode.indexOf('```');
            final endIndex = rawCode.indexOf('```', startIndex + 3);
            if (startIndex == -1 || endIndex == -1) {
              throw Exception('badly-formatted');
            }
            // Call the runCode function to execute code and send the returned value as a message
            String code = rawCode.substring(startIndex + 3, endIndex).trim();
            Commands.runCode(code).then((value) {
              event.message.channel.sendMessage(MessageBuilder.content(
                  '```ansi\n${value.outputMessage + OutputFormatter.formatError(value.errorMessage)}```\nExited (${value.exitCode})')
                ..replyBuilder = ReplyBuilder.fromMessage(event.message));
            });
          } catch (e) {
            await event.message.channel.sendMessage(
              CustomMessageBuilder.build(
                  authorName: 'Invalid',
                  title: 'I couldn\'t understand',
                  description:
                      'Looks like your command was badly formatted, find out how to correctly use the run command from the message below.')
                ..replyBuilder = ReplyBuilder.fromMessage(event.message),
            );
            Commands.helpSpecific(['run'])
                .then((value) => event.message.channel.sendMessage(
                      value
                        ..replyBuilder =
                            ReplyBuilder.fromMessage(event.message),
                    ));
          }

          break;
        default:
          Commands.helpSpecific([command])
              .then((value) => event.message.channel.sendMessage(
                    value
                      ..replyBuilder = ReplyBuilder.fromMessage(event.message),
                  ));
      }
    });
  }
}
