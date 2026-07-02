import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:crypto/crypto.dart';

class EncryptionService {
  static const _storage = FlutterSecureStorage();
  static const _keyName = 'pastoral_notes_key';
  static const _ivName = 'pastoral_notes_iv';
  
  /// Génère une clé de chiffrement unique (à exécuter une fois par appareil)
  static Future<void> initializeKey() async {
    try {
      final existingKey = await _storage.read(key: _keyName);
      if (existingKey == null) {
        final key = encrypt.Key.fromSecureRandom(32); // AES-256
        final iv = encrypt.IV.fromSecureRandom(16);
        await _storage.write(key: _keyName, value: base64Encode(key.bytes));
        await _storage.write(key: _ivName, value: base64Encode(iv.bytes));
      }
    } catch (e) {
      debugPrint('Warning: Encryption service not available on this device: $e');
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

  /// Exporte les clés actuelles sous forme de chaîne chiffrée par un mot de passe
  static Future<String?> exportBackup(String password) async {
    try {
      final keyBase64 = await _storage.read(key: _keyName);
      final ivBase64 = await _storage.read(key: _ivName);
      
      if (keyBase64 == null || ivBase64 == null) return null;

      final dataToExport = jsonEncode({
        'key': keyBase64,
        'iv': ivBase64,
      });

      // Chiffrement du backup avec le mot de passe utilisateur
      final keyHash = sha256.convert(utf8.encode(password)).bytes;
      final backupKey = encrypt.Key(Uint8List.fromList(keyHash));
      final backupIv = encrypt.IV.fromLength(16);
      final encrypter = encrypt.Encrypter(encrypt.AES(backupKey));

      final encrypted = encrypter.encrypt(dataToExport, iv: backupIv);
      return '${backupIv.base64}:${encrypted.base64}';
    } catch (e) {
      return null;
    }
  }

  /// Restaure les clés à partir d'un backup et du mot de passe
  static Future<bool> restoreBackup(String backupString, String password) async {
    try {
      final parts = backupString.split(':');
      if (parts.length != 2) return false;

      final backupIv = encrypt.IV.fromBase64(parts[0]);
      final encryptedData = encrypt.Encrypted.fromBase64(parts[1]);

      final keyHash = sha256.convert(utf8.encode(password)).bytes;
      final backupKey = encrypt.Key(Uint8List.fromList(keyHash));
      final encrypter = encrypt.Encrypter(encrypt.AES(backupKey));

      final decrypted = encrypter.decrypt(encryptedData, iv: backupIv);
      final Map<String, dynamic> keys = jsonDecode(decrypted);

      await _storage.write(key: _keyName, value: keys['key']);
      await _storage.write(key: _ivName, value: keys['iv']);
      return true;
    } catch (e) {
      return false;
    }
  }
  
  /// Efface la clé (déconnexion, changement d'utilisateur)
  static Future<void> wipeKey() async {
    await _storage.delete(key: _keyName);
    await _storage.delete(key: _ivName);
  }
}

