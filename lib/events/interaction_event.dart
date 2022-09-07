import 'package:dart_runner_bot/commands/commands.dart';
import 'package:dart_runner_bot/services/env_loader.dart';
import 'package:dart_runner_bot/services/output_formatter.dart';
import 'package:nyxx/nyxx.dart';
import 'package:nyxx_interactions/nyxx_interactions.dart';

class InteractionEvent {
  static Future<void> onMessageReceived(INyxxWebsocket client) async {
    client.eventsWs.onMessageReceived.listen((event) {
      String msgText = event.message.content;

      /// This makes your bot ignore other bots and itself
      /// and not get into a spam loop (we call that "botception").
      if (event.message.author.bot) return;

      if (!msgText.startsWith(EnvLoader.prefix)) return;

      msgText = msgText.substring(EnvLoader.prefix.length);

      if (msgText.startsWith('help')) {
        ComponentMessageBuilder componentMessageBuilder =
            ComponentMessageBuilder();

        EmbedBuilder embed = EmbedBuilder()
          ..addFooter((EmbedFooterBuilder footer) {
            footer.text =
                'Love this bot? Star it on GitHub:\nhttps://github.com/Anikate-De/Dart-Runner-Bot';
            footer.iconUrl =
                'https://avatars.githubusercontent.com/u/40452578?v=4';
          });

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

        embed.title = 'Hi! I\'m the `Dart Runner Bot`';
        embed.description =
            'Hit me up if you want to execute some dart code right here on Discord.';
        embed.fields.addAll(helpFields);
        embed.color = DiscordColor.dartBlue;
        embed.author = EmbedAuthorBuilder()
          ..iconUrl =
              'https://cdn.discordapp.com/attachments/756903745241088011/775823137312210974/dart.png'
          ..name = 'Help • Dart Runner Bot';
        embed.timestamp = DateTime.now();

        event.message.channel.sendMessage(
          componentMessageBuilder
            ..embeds = <EmbedBuilder>[embed]
            ..replyBuilder = ReplyBuilder.fromMessage(event.message),
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
