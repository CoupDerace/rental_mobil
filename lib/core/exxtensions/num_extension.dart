extension NumExtension on num {
  String get currency {
    final value = toStringAsFixed(0);

    final chars = value.split('').reversed.toList();

    final buffer = StringBuffer();

    for (int i = 0; i < chars.length; i++) {
      if (i != 0 && i % 3 == 0) {
        buffer.write('.');
      }

      buffer.write(chars[i]);
    }

    return "Rp ${buffer.toString().split('').reversed.join()}";
  }

  String get twoDecimal {
    return toStringAsFixed(2);
  }

  Duration get milliseconds => Duration(milliseconds: toInt());

  Duration get seconds => Duration(seconds: toInt());

  Duration get minutes => Duration(minutes: toInt());
}
