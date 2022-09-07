import 'package:dotenv/dotenv.dart' as dotenv;
import 'package:nyxx/nyxx.dart';

class EnvLoader {
  static String get token {
    dotenv.load();
    if (!dotenv.isEveryDefined(['TOKEN'])) {
      throw MissingTokenError();
    }
    return dotenv.env['TOKEN']!;
  }

  static String get prefix {
    dotenv.load();
    if (!dotenv.isEveryDefined(['PREFIX'])) {
      return 'dart!';
    }
    return dotenv.env['PREFIX']!;
  }
}
