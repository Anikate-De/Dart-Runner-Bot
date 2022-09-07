import 'package:dart_runner_bot/events/client_event.dart';
import 'package:dart_runner_bot/events/interaction_event.dart';
import 'package:dart_runner_bot/services/env_loader.dart';
import 'package:dart_runner_bot/services/logger.dart';
import 'package:nyxx/nyxx.dart';

void main(List<String> arguments) async {
  try {
    // Create new bot instance
    final INyxxWebsocket botClient =
        NyxxFactory.createNyxxWebsocket(EnvLoader.token(), GatewayIntents.all)
          ..registerPlugin(Logging()) // Default logging plugin
          ..registerPlugin(
              CliIntegration()) // Cli integration for nyxx allows stopping application via SIGTERM and SIGKILl
          ..registerPlugin(
              IgnoreExceptions()) // Plugin that handles uncaught exceptions that may occur
          ..connect();

    await ClientEvent.onReadyEvent(botClient);
    await InteractionEvent.onMessageReceived(botClient);
  } on MissingTokenError catch (e) {
    Logger.log(LogType.error, e.toString());
  } catch (err) {
    Logger.log(LogType.error, err.toString());
  }
}
