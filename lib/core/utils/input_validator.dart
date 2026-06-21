class InputValidator {
  InputValidator._();

  static String? required(String? value, {String field = 'Field'}) {
    if (value == null || value.trim().isEmpty) {
      return '$field wajib diisi';
    }

    return null;
  }

  static String? email(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email wajib diisi';
    }

    final regex = RegExp(r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$');

    if (!regex.hasMatch(value)) {
      return 'Format email tidak valid';
    }

    return null;
  }

  static String? password(String? value) {
    if (value == null || value.length < 6) {
      return 'Minimal 6 karakter';
    }

    return null;
  }

  static String? phone(String? value) {
    if (value == null || value.isEmpty) {
      return 'Nomor HP wajib diisi';
    }

    if (value.length < 10) {
      return 'Nomor HP tidak valid';
    }

    return null;
  }
}
