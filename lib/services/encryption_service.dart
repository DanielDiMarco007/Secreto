import 'package:encrypt/encrypt.dart';

class EncryptionService {
  EncryptionService._();

  static final Key _key = Key.fromUtf8(
    '12345678901234567890123456789012',
  );

  static final IV _iv = IV.fromLength(16);

  static final Encrypter _encrypter =
      Encrypter(AES(_key));

  static String encrypt(String text) {
    return _encrypter.encrypt(
      text,
      iv: _iv,
    ).base64;
  }

  static String decrypt(String encryptedText) {
    return _encrypter.decrypt64(
      encryptedText,
      iv: _iv,
    );
  }
}