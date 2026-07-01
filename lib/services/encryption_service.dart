import 'package:encrypt/encrypt.dart';

class EncryptionService {
  EncryptionService._();

  static final Key _key = Key.fromUtf8('0123456789ABCDEF0123456789ABCDEF');

  static final Encrypter _encrypter = Encrypter(AES(_key));

  static String encrypt(String plainText) {
    final iv = IV.fromSecureRandom(16);

    final encrypted = _encrypter.encrypt(plainText, iv: iv);

    return '${iv.base64}:${encrypted.base64}';
  }

  static String decrypt(String encryptedText) {
    final parts = encryptedText.split(':');

    final iv = IV.fromBase64(parts[0]);

    return _encrypter.decrypt64(parts[1], iv: iv);
  }
}
