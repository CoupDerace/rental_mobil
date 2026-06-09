import 'package:intl/intl.dart';

class Formatters {
  static final _currencyFormatter = NumberFormat.currency(
    locale: 'id_ID',
    symbol: 'Rp ',
    decimalDigits: 0,
  );

  static final _dateFormatter = DateFormat('dd MMM yyyy', 'id_ID');
  static final _dateShortFormatter = DateFormat('dd/MM/yyyy');
  static final _monthFormatter = DateFormat('MMMM yyyy', 'id_ID');

  /// Format a number as Indonesian Rupiah (e.g. Rp 2.400.000)
  static String currency(num value) {
    return _currencyFormatter.format(value);
  }

  /// Format a number as abbreviated millions (e.g. 24.8M)
  static String currencyShort(num value) {
    if (value >= 1000000) {
      return 'Rp ${(value / 1000000).toStringAsFixed(1)}M';
    } else if (value >= 1000) {
      return 'Rp ${(value / 1000).toStringAsFixed(0)}K';
    }
    return currency(value);
  }

  /// Format a DateTime as "08 Jun 2026"
  static String date(DateTime date) {
    return _dateFormatter.format(date);
  }

  /// Format a date string (yyyy-MM-dd) as "08 Jun 2026"
  static String dateFromString(String dateStr) {
    try {
      final dt = DateTime.parse(dateStr);
      return _dateFormatter.format(dt);
    } catch (_) {
      return dateStr;
    }
  }

  /// Format as "08/06/2026"
  static String dateShort(DateTime date) {
    return _dateShortFormatter.format(date);
  }

  /// Format as "Juni 2026"
  static String month(DateTime date) {
    return _monthFormatter.format(date);
  }

  /// Abbreviate a large number (e.g. 24800000 -> "24.8M")
  static String compactNumber(num value) {
    if (value >= 1000000) {
      return '${(value / 1000000).toStringAsFixed(1)}M';
    } else if (value >= 1000) {
      return '${(value / 1000).toStringAsFixed(0)}K';
    }
    return value.toStringAsFixed(0);
  }
}
