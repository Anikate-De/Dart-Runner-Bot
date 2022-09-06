import 'package:dart_runner_bot/dart_runner_bot.dart';
import 'package:nyxx/nyxx.dart';
import 'package:dotenv/dotenv.dart' as dotenv;

void main(List<String> arguments) async {
  dotenv.load();

  // Create new bot instance
  final bot =
      NyxxFactory.createNyxxWebsocket(dotenv.env['TOKEN']!, GatewayIntents.all)
        ..registerPlugin(Logging()) // Default logging plugin
        ..registerPlugin(
            CliIntegration()) // Cli integration for nyxx allows stopping application via SIGTERM and SIGKILl
        ..registerPlugin(
            IgnoreExceptions()) // Plugin that handles uncaught exceptions that may occur
        ..connect();

  // Listen to ready event. Invoked when bot is connected to all shards. Note that cache can be empty or not incomplete.
  bot.eventsWs.onReady.listen((e) {
    print("Ready!");
  });

  // Listen to all incoming messages
  bot.eventsWs.onMessageReceived.listen((e) {
    String msgText = e.message.content;

    // Check if message content equals "!ping"
    if (msgText.startsWith("!ping")) {
      // Send "Pong!" to channel where message was received
      e.message.channel.sendMessage(MessageBuilder.content("Pong!"));
    }

    // Check if message content equals "!run"
    if (msgText.startsWith('!run')) {
      // Extract the dart code, present within '```'
      final startIndex = msgText.indexOf('```');
      final endIndex = msgText.indexOf('```', startIndex + 3);

      // Call the runCode function to execute code and send the returned value to Discord
      String code = msgText.substring(startIndex + 3, endIndex).trim();
      runCode(code).then((value) => e.message.channel
          .sendMessage(MessageBuilder.content('```$value```')));
    }
  });
}
