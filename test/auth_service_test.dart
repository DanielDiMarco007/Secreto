import 'package:buzon_secreto/services/auth_service.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AuthService input validation', () {
    test('accepts valid email and password', () {
      final error = AuthService.validateRegistrationInput(
        email: 'usuario@test.com',
        password: '123456',
      );

      expect(error, isNull);
    });

    test('rejects empty email', () {
      final error = AuthService.validateRegistrationInput(
        email: '',
        password: '123456',
      );

      expect(error, 'Ingresa un correo válido');
    });

    test('rejects weak password', () {
      final error = AuthService.validateRegistrationInput(
        email: 'usuario@test.com',
        password: '123',
      );

      expect(error, 'La contraseña debe tener al menos 6 caracteres');
    });
  });
}
