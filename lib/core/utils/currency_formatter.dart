class CurrencyFormatter {
  CurrencyFormatter._();

  static String format(num value) {
    final text = value.toStringAsFixed(0);

    final chars = text.split('').reversed.toList();

    final buffer = StringBuffer();

    for (int i = 0; i < chars.length; i++) {
      if (i != 0 && i % 3 == 0) {
        buffer.write('.');
      }

      buffer.write(chars[i]);
    }

    return 'Rp ${buffer.toString().split('').reversed.join()}';
  }
}
