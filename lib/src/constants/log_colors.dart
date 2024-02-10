// ignore_for_file: constant_identifier_names

class LogColors {
  static const String BLACK = '\x1B[30m';
  static const String RED = '\x1B[31m';
  static const String GREEN = '\x1B[38;2;30;215;96;m';
  static const String YELLOW = '\x1B[33m';
  static const String BLUE = '\x1B[34m';
  static const String BLUE_LIGHT = '\x1B[38;2;0;141;253;m';
  static const String AQUA = '\x1B[38;2;183;220;214;m';
  static const String MAGENTA = '\x1B[35m';
  static const String CYAN = '\x1B[36m';
  static const String WHITE = '\x1B[37m';
  static const String ACCENT_GREEN = '\x1B[92m';
  static const String ORANGE = '\x1B[38;2;251;192;45;m';
  static const String PINK = '\x1B[38;2;241;125;164;m';
  static const String GREY = '\x1B[38;2;128;128;128;m';

  static const String METHOD_GET = '\x1B[38;2;66;170;248;m'; // Blue
  static const String METHOD_POST = '\x1B[38;2;29;191;94;m'; // Green
  static const String METHOD_PUT = '\x1B[38;2;255;161;0;m'; // Orange
  static const String METHOD_DELETE = '\x1B[38;2;252;75;79;m'; // Red
  static const String METHOD_PATCH = '\x1B[38;2;255;161;0;m'; // Orange
  static const String METHOD_HEAD = '\x1B[38;2;153;102;204;m'; // Purple

  static const String STATUSCODE_200 = '\x1B[38;2;53;183;41;m'; // Green
  static const String STATUSCODE_300 = '\x1B[38;2;82;113;255;m'; // Blue
  static const String STATUSCODE_400 = '\x1B[38;2;255;92;92;m'; // Red
  static const String STATUSCODE_500 = '\x1B[38;2;255;162;0;m'; // Orange
}
