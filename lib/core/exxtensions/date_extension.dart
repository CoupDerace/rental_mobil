extension DateExtension on DateTime {
  String get yyyyMMdd {
    return "${year.toString().padLeft(4, '0')}-"
        "${month.toString().padLeft(2, '0')}-"
        "${day.toString().padLeft(2, '0')}";
  }

  String get ddMMyyyy {
    return "${day.toString().padLeft(2, '0')}/"
        "${month.toString().padLeft(2, '0')}/"
        "$year";
  }

  String get fullDate {
    const months = [
      '',
      'Januari',
      'Februari',
      'Maret',
      'April',
      'Mei',
      'Juni',
      'Juli',
      'Agustus',
      'September',
      'Oktober',
      'November',
      'Desember',
    ];

    return "$day ${months[month]} $year";
  }

  bool get isToday {
    final now = DateTime.now();

    return day == now.day && month == now.month && year == now.year;
  }
}
