import 'package:flutter/material.dart';

class NavigationService {
  NavigationService._();

  static final navigatorKey = GlobalKey<NavigatorState>();

  static NavigatorState? get navigator => navigatorKey.currentState;

  static Future<T?> push<T>(Route<T> route) {
    return navigator!.push(route);
  }

  static Future<T?> pushNamed<T>(String route) {
    return navigator!.pushNamed<T>(route);
  }

  static void pop<T>([T? result]) {
    navigator?.pop(result);
  }

  static Future<T?> pushReplacementNamed<T>(String route) {
    return navigator!.pushReplacementNamed<T, dynamic>(route);
  }
}
