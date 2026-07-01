class AuthService {
  AuthService._();

  static String? validateRegistrationInput({
    required String email,
    required String password,
  }) {
    final normalizedEmail = email.trim();
    final normalizedPassword = password.trim();

    if (normalizedEmail.isEmpty) {
      return 'Ingresa un correo válido';
    }

    if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(normalizedEmail)) {
      return 'Correo inválido';
    }

    if (normalizedPassword.length < 6) {
      return 'La contraseña debe tener al menos 6 caracteres';
    }

    return null;
  }

  static Future<void> signIn({
    required String email,
    required String password,
  }) async {
    final validationError = validateRegistrationInput(
      email: email,
      password: password,
    );

    if (validationError != null) {
      throw Exception(validationError);
    }
  }

  static Future<void> register({
    required String email,
    required String password,
  }) async {
    final validationError = validateRegistrationInput(
      email: email,
      password: password,
    );

    if (validationError != null) {
      throw Exception(validationError);
    }
  }

  static Future<void> signOut() async {}
}
