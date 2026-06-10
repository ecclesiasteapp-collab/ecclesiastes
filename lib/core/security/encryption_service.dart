import 'dart:convert';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class EncryptionService {
  static const _storage = FlutterSecureStorage();
  static const _keyName = 'pastoral_notes_key';
  static const _ivName = 'pastoral_notes_iv';
  
  /// Génère une clé de chiffrement unique (à exécuter une fois par appareil)
  static Future<void> initializeKey() async {
    final existingKey = await _storage.read(key: _keyName);
    if (existingKey == null) {
      final key = encrypt.Key.fromSecureRandom(32); // AES-256
      final iv = encrypt.IV.fromSecureRandom(16);
      await _storage.write(key: _keyName, value: base64Encode(key.bytes));
      await _storage.write(key: _ivName, value: base64Encode(iv.bytes));
    }
  }
  
  /// Chiffre un texte pastoral
  static Future<String> encryptPastoralNote(String plainText) async {
    final keyBase64 = await _storage.read(key: _keyName);
    final ivBase64 = await _storage.read(key: _ivName);
    
    if (keyBase64 == null || ivBase64 == null) {
      throw Exception('Clé de chiffrement non initialisée');
    }
    
    final key = encrypt.Key(base64Decode(keyBase64));
    final iv = encrypt.IV(base64Decode(ivBase64));
    final encrypter = encrypt.Encrypter(encrypt.AES(key));
    
    return encrypter.encrypt(plainText, iv: iv).base64;
  }
  
  /// Déchiffre un texte pastoral
  static Future<String> decryptPastoralNote(String encryptedText) async {
    final keyBase64 = await _storage.read(key: _keyName);
    final ivBase64 = await _storage.read(key: _ivName);
    
    if (keyBase64 == null || ivBase64 == null) {
      throw Exception('Clé de chiffrement non initialisée');
    }
    
    final key = encrypt.Key(base64Decode(keyBase64));
    final iv = encrypt.IV(base64Decode(ivBase64));
    final encrypter = encrypt.Encrypter(encrypt.AES(key));
    
    return encrypter.decrypt64(encryptedText, iv: iv);
  }
  
  /// Efface la clé (déconnexion, changement d'utilisateur)
  static Future<void> wipeKey() async {
    await _storage.delete(key: _keyName);
    await _storage.delete(key: _ivName);
  }
}
