import 'package:encrypt/encrypt.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class PastoralEncryptionService {
  static final _storage = const FlutterSecureStorage();
  static Encrypter? _encrypter;
  static final _iv = IV.fromLength(16);

  static Future<void> init() async {
    String? keyString = await _storage.read(key: 'pastoral_key');
    if (keyString == null) {
      final newKey = Key.fromSecureRandom(32);
      await _storage.write(key: 'pastoral_key', value: newKey.base64);
      keyString = newKey.base64;
    }
    final key = Key.fromBase64(keyString);
    _encrypter = Encrypter(AES(key));
  }

  static String encrypt(String text) {
    if (_encrypter == null) return text;
    return _encrypter!.encrypt(text, iv: _iv).base64;
  }

  static String decrypt(String encryptedBase64) {
    if (_encrypter == null) return encryptedBase64;
    return _encrypter!.decrypt(Encrypted.fromBase64(encryptedBase64), iv: _iv);
  }
}
