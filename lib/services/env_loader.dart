import 'package:dotenv/dotenv.dart' as dotenv;
import 'package:nyxx/nyxx.dart';

class EnvLoader {
  static String token() {
    dotenv.load();
    if (!dotenv.isEveryDefined(['TOKEN'])) {
      throw MissingTokenError();
    }
    return dotenv.env['TOKEN']!;
  }
}
