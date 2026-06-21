import 'package:intl/intl.dart';

extension DateExtension on DateTime {
  String get ddMMyyyy {
    return DateFormat("dd/MM/yyyy").format(this);
  }

  String get yyyyMMdd {
    return DateFormat("yyyy-MM-dd").format(this);
  }

  String get fullDate {
    return DateFormat("dd MMMM yyyy", "id_ID").format(this);
  }

  String get fullDateTime {
    return DateFormat("dd MMM yyyy HH:mm", "id_ID").format(this);
  }
}
