class InputValidator {
  InputValidator._();

  static String? required(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Field wajib diisi';
    }

    return null;
  }

  static String? email(String? value) {
    if (required(value) != null) {
      return required(value);
    }

    final regex = RegExp(r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$');

    if (!regex.hasMatch(value!)) {
      return 'Format email tidak valid';
    }

    return null;
  }

  static String? password(String? value) {
    if (required(value) != null) {
      return required(value);
    }

    if (value!.length < 6) {
      return 'Minimal 6 karakter';
    }

    return null;
  }
}
