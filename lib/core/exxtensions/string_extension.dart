extension StringExtension on String {
  bool get isEmail {
    final emailRegex = RegExp(r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$');

    return emailRegex.hasMatch(this);
  }

  bool get isNotBlank => trim().isNotEmpty;

  String get capitalize {
    if (isEmpty) return this;

    return "${this[0].toUpperCase()}${substring(1)}";
  }

  String get titleCase {
    return split(" ").map((e) => e.capitalize).join(" ");
  }
}
