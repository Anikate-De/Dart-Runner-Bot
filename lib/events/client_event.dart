import './../services/logger.dart';
import 'package:nyxx/nyxx.dart';

class ClientEvent {
  // Listen to ready event. Invoked when bot is connected to all shards. Note that cache can be empty or not incomplete.
  static Future<void> onReadyEvent(INyxxWebsocket client) async {
    client.eventsWs.onReady.listen((_) async {
      try {
        /// Set the bot activity to listening.
        client.setPresence(
          PresenceBuilder.of(
            status: UserStatus.online,
            activity: ActivityBuilder.listening('your commands')
              ..url = 'https://dart.dev/',
          ),
        );
        Logger.log(LogType.success, '${client.self.tag} is up and running 🚀');
      } catch (e) {
        Logger.log(LogType.error, e.toString());
      }
    });
  }
}
