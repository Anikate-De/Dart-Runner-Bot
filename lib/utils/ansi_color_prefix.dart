class AnsiColorPrefix {
  static final String _base = '\u001b[0;';

  static String get yellow => "${_base}33m";

  static String get boldBlack => "${_base}30;1m";

  static String get white => "${_base}37m";
}
