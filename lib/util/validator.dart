class Validator {
  static String? validateEmpty({required String? name}) {
    if (name == null) {
      return null;
    }

    if (name.isEmpty) {
      return 'Kolom tidak boleh kosong';
    }
    return null;
  }

  static String? validatePhone({required String? phone}) {
    if (phone == null || phone.isEmpty) {
      return 'Angka tidak boleh kosong';
    }
    if (!RegExp(r'^[0-9]+$').hasMatch(phone)) {
      return 'Masukkan angka yang valid';
    }
    return null;
  }

  static String? validateName({required String? name}) {
    if (name == null) {
      return null;
    }

    if (name.isEmpty) {
      return 'Nama tidak boleh kosong';
    }
    return null;
  }

  static String? validateEmail({required String? email}) {
    if (email == null) {
      return null;
    }

    RegExp emailRegExp = RegExp(
        r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z09-]{0,253}[a-zA-Z0-9])?)*$");

    if (email.isEmpty) {
      return 'Email tidak boleh kosong';
    } else if (!emailRegExp.hasMatch(email)) {
      return 'masukkan email yang valid';
    }
    return null;
  }

  static String? validatePassword({required String? password}) {
    if (password == null) {
      return null;
    }

    if (password.isEmpty) {
      return 'Password tidak boleh kosong';
    } else if (password.length < 6) {
      return 'masukkan password minimal 6 karakter';
    }
    return null;
  }
}
