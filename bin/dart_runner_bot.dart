import 'dart:io';

import 'package:dart_runner_bot/events/client_event.dart';
import 'package:dart_runner_bot/events/interaction_event.dart';
import 'package:dart_runner_bot/services/env_loader.dart';
import 'package:dart_runner_bot/services/logger.dart';
import 'package:nyxx/nyxx.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;
import 'package:shelf_router/shelf_router.dart' as shelf_router;

Response _helloWorldHandler(Request request) =>
    Response.ok('Dart Runner Bot bot is up and wonderful!');

void main(List<String> arguments) async {
  final router = shelf_router.Router()..get('/ping', _helloWorldHandler);

  // If the "PORT" environment variable is set, listen to it. Otherwise, 8080.
  // https://cloud.google.com/run/docs/reference/container-contract#port
  final port = int.parse(Platform.environment['PORT'] ?? '8080');

  // See https://pub.dev/documentation/shelf/latest/shelf/Cascade-class.html
  final cascade = Cascade()
      // If a corresponding file is not found, send requests to a `Router`
      .add(router);

  // See https://pub.dev/documentation/shelf/latest/shelf_io/serve.html
  final server = await shelf_io.serve(
    // See https://pub.dev/documentation/shelf/latest/shelf/logRequests.html
    logRequests()
        // See https://pub.dev/documentation/shelf/latest/shelf/MiddlewareExtensions/addHandler.html
        .addHandler(cascade.handler),
    InternetAddress.anyIPv4, // Allows external connections
    port,
  );

  print('Serving at http://${server.address.host}:${server.port}');

  try {
    // Create new bot instance
    final INyxxWebsocket botClient =
        NyxxFactory.createNyxxWebsocket(EnvLoader.token, GatewayIntents.all)
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
