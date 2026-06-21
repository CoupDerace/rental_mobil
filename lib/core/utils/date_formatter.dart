import 'package:intl/intl.dart';

class DateFormatter {
  DateFormatter._();

  static String format(DateTime date, {String pattern = 'dd MMM yyyy'}) {
    return DateFormat(pattern, 'id_ID').format(date);
  }
}
