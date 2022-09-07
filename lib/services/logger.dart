// 📦 Package imports:
import 'package:intl/intl.dart';
import 'package:nyxx/nyxx.dart';

import 'custom_print_util.dart' as console;

/// LoggerType Enum
enum LogType { success, info, warning, error }

/// Logger class
class Logger {
  /// Logger method to log depending on [LogType]
  static void log(LogType? tag, String? message) {
    /// Get the current date and time
    String time = DateFormat.yMEd().add_jms().format(DateTime.now());
    switch (tag) {
      case LogType.success:
        console.success('SUCCESS [$time] - $message');
        break;
      case LogType.info:
        console.info('INFORMATION [$time] - $message');
        break;
      case LogType.warning:
        console.log('WARNING [$time] - $message');
        break;
      case LogType.error:
        console.error(
            'ERROR [$time] - $message\n[StackTraces] - ${StackTrace.current}');
        break;
      default:
        print('LOG [$time] - $message');
    }
  }
}

/// Sends the message to the channel and logs it.
Future<void> logAndSendMessage(IMessageReceivedEvent event,
    MessageBuilder messageBuilder, LogType logType, String logMessage) async {
  await event.message.channel.sendMessage(messageBuilder);
  Logger.log(logType, logMessage);
}
