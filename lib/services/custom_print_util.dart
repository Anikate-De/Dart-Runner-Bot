/// Prints the given message to the console as ***`Warning`***.
void log(String text) {
  print('\x1B[33m$text\x1B[0m');
}

/// Prints the given message to the console as ***`Error`***.
void error(String text) {
  print('\x1B[31m$text\x1B[0m');
}

/// Prints the given message to the console as ***`Information`***.
void info(String text) {
  print('\x1B[36m$text\x1B[0m');
}

/// Prints the given message to the console as ***`Information`***.
void success(String text) {
  print('\x1B[32m$text\x1B[0m');
}
