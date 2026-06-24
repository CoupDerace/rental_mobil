extension StringExtension on String {
  bool get isEmail {
    return RegExp(r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(this);
  }

  bool get isPhone {
    return RegExp(r'^[0-9]{10,15}$').hasMatch(this);
  }

  bool get isNumeric {
    return double.tryParse(this) != null;
  }

  String get capitalize {
    if (isEmpty) return this;

    return this[0].toUpperCase() + substring(1).toLowerCase();
  }

  String get titleCase {
    return split(' ').map((e) => e.capitalize).join(' ');
  }

  String get initials {
    final parts = trim().split(' ');

    if (parts.isEmpty) return '';

    if (parts.length == 1) {
      return parts.first.substring(0, 1).toUpperCase();
    }

    return (parts.first[0] + parts.last[0]).toUpperCase();
  }
}
