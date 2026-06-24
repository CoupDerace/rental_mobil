import 'package:flutter/material.dart';

extension ContextExtension on BuildContext {
  ThemeData get theme => Theme.of(this);

  ColorScheme get colorScheme => theme.colorScheme;

  TextTheme get textTheme => theme.textTheme;

  Size get screenSize => MediaQuery.sizeOf(this);

  double get width => screenSize.width;

  double get height => screenSize.height;

  bool get isMobile => width < 600;

  bool get isTablet => width >= 600 && width < 1024;

  bool get isDesktop => width >= 1024;

  void pop<T extends Object?>([T? result]) {
    Navigator.of(this).pop(result);
  }

  Future<T?> push<T>(Widget page) {
    return Navigator.push<T>(this, MaterialPageRoute(builder: (_) => page));
  }

  Future<T?> pushReplacement<T>(Widget page) {
    return Navigator.pushReplacement<T, dynamic>(
      this,
      MaterialPageRoute(builder: (_) => page),
    );
  }
}
