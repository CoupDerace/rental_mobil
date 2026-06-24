import 'dart:developer';

class Logger {
  Logger._();

  static void info(Object? message) {
    log('$message', name: 'INFO');
  }

  static void warning(Object? message) {
    log('$message', name: 'WARNING');
  }

  static void error(Object? message) {
    log('$message', name: 'ERROR');
  }
}
