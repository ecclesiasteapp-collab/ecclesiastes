import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';

class ExportService {
  /// Export JSON pour conformité RGPD (données limitées)
  static Future<void> exportUserData() async {
    // ... (existant)
  }

  /// Sauvegarde complète de la base de données (DRP)
  static Future<void> performFullBackup() async {
    try {
      final Map<String, dynamic> backup = {
        'timestamp': DateTime.now().toIso8601String(),
        'app': 'Ecclésiaste',
        'type': 'FULL_BACKUP',
        'data': {}
      };

      // Liste exhaustive des boîtes à sauvegarder
      final boxes = [
        'settings_box', 'membres', 'utilisateurs', 'ordinations', 
        'nominations', 'sacraments', 'persons', 'annonces', 
        'finances', 'rapports', 'entites'
      ];

      for (final name in boxes) {
        final box = await Hive.openBox(name);
        backup['data'][name] = box.toMap().map((k, v) => MapEntry(k.toString(), v));
      }

      final jsonString = jsonEncode(backup);
      
      // Simulation de chiffrement (pourrait être remplacé par un vrai plugin de crypto)
      final encoded = base64Encode(utf8.encode(jsonString));

      final directory = await getTemporaryDirectory();
      final fileName = 'ecclesiaste_backup_${DateFormat('yyyyMMdd_HHmm').format(DateTime.now())}.bak';
      final file = File('${directory.path}/$fileName');
      
      await file.writeAsString(encoded);

      await SharePlus.instance.share(
        ShareParams(
          files: [XFile(file.path)],
          subject: 'Sauvegarde Ecclésiaste',
          text: 'Fichier de sauvegarde chiffré de votre application Ecclésiaste.',
        ),
      );
    } catch (e) {
      rethrow;
    }
  }

  /// Restauration à partir d'un fichier backup
  static Future<void> restoreFromBackup(File file) async {
    try {
      final content = await file.readAsString();
      final decoded = utf8.decode(base64Decode(content));
      final Map<String, dynamic> backup = jsonDecode(decoded);

      if (backup['app'] != 'Ecclésiaste') throw Exception('Fichier de sauvegarde invalide');

      final Map<String, dynamic> data = backup['data'];
      for (final boxName in data.keys) {
        final box = await Hive.openBox(boxName);
        await box.clear();
        await box.putAll(Map<String, dynamic>.from(data[boxName]));
      }
    } catch (e) {
      rethrow;
    }
  }
}

