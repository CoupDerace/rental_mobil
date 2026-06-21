extension NumExtension on num {
  double get h => toDouble();

  double get w => toDouble();

  Duration get milliseconds => Duration(milliseconds: toInt());

  Duration get seconds => Duration(seconds: toInt());

  Duration get minutes => Duration(minutes: toInt());
}
