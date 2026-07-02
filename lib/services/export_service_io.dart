import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';

class ExportService {
  static Future<void> exportUserData() async {
    try {
      final Map<String, dynamic> allData = {};
      
      // Collecter les données de toutes les boîtes importantes
      final boxesToExport = ['settings_box', 'membres', 'utilisateurs', 'bible_notes'];
      
      for (final boxName in boxesToExport) {
        if (Hive.isBoxOpen(boxName)) {
          final box = Hive.box(boxName);
          // Conversion explicite en Map<String, dynamic> pour éviter les erreurs de sérialisation JSON d'objets typés
          allData[boxName] = Map<String, dynamic>.from(
            box.toMap().map((key, value) => MapEntry(key.toString(), value is HiveObject ? value.toString() : value))
          );
        } else {
          final box = await Hive.openBox(boxName);
          allData[boxName] = Map<String, dynamic>.from(
            box.toMap().map((key, value) => MapEntry(key.toString(), value is HiveObject ? value.toString() : value))
          );
        }
      }

      // Ajouter des métadonnées
      allData['export_metadata'] = {
        'app': 'Ecclésiaste',
        'version': '1.0.0+1',
        'export_date': DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now()),
        'format': 'RGPD JSON Export'
      };

      final String jsonString = const JsonEncoder.withIndent('  ').convert(allData);
      
      // Sauvegarder dans un fichier temporaire
      final directory = await getTemporaryDirectory();
      final fileName = 'ecclesiaste_export_${DateTime.now().millisecondsSinceEpoch}.json';
      final file = File('${directory.path}/$fileName');
      
      await file.writeAsString(jsonString);

      // Partager le fichier
      await SharePlus.instance.share(
        ShareParams(
          files: [XFile(file.path)],
          subject: 'Export de mes données Ecclésiaste (RGPD)',
          text: 'Voici l\'exportation de vos données personnelles de l\'application Ecclésiaste.',
        ),
      );
      
    } catch (e) {
      rethrow;
    }
  }
}

