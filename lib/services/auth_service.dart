import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  AuthService._();

  static final FirebaseAuth _auth = FirebaseAuth.instance;

  static User? get currentUser => _auth.currentUser;

  static Stream<User?> get authStateChanges => _auth.authStateChanges();

  static Future<UserCredential> signIn({
    required String email,
    required String password,
  }) async {
    try {
      return await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );
    } on FirebaseAuthException catch (e) {
      throw Exception(_getErrorMessage(e));
    }
  }

  static Future<UserCredential> register({
    required String email,
    required String password,
  }) async {
    try {
      return await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );
    } on FirebaseAuthException catch (e) {
      throw Exception(_getErrorMessage(e));
    }
  }

  static Future<void> signOut() async {
    await _auth.signOut();
  }

  static String _getErrorMessage(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return 'Usuario no encontrado';

      case 'wrong-password':
        return 'Contraseña incorrecta';

      case 'email-already-in-use':
        return 'El correo ya está registrado';

      case 'invalid-email':
        return 'Correo inválido';

      case 'weak-password':
        return 'La contraseña es demasiado débil';

      case 'operation-not-allowed':
        return 'El método de autenticación no está habilitado';

      case 'configuration-not-found':
        return 'Configuración de Firebase no encontrada. Revisa google-services.json y la consola de Firebase';

      case 'internal-error':
        return 'Error interno de Firebase. Intenta nuevamente más tarde';

      default:
        return e.message ?? 'Error de autenticación';
    }
  }
}
