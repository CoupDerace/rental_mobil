import 'package:logger/logger.dart';

class AppLogger {
  AppLogger._();

  static final Logger instance = Logger();

  static void info(dynamic message) {
    instance.i(message);
  }

  static void warning(dynamic message) {
    instance.w(message);
  }

  static void error(dynamic message) {
    instance.e(message);
  }

  static void debug(dynamic message) {
    instance.d(message);
  }
}
