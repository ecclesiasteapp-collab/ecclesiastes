import 'package:file_picker/file_picker.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/foundation.dart';
import 'dart:io' show File;

class FileService {
  /// Ouvre un sélecteur de fichiers compatible Mobile et Web
  /// Sur Web, le 'path' sera null, il faut utiliser 'bytes'.
  static Future<FilePickerResult?> pickFile() async {
    try {
      final FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'jpg', 'png', 'doc', 'docx', 'xlsx', 'xls'],
        withData: kIsWeb, // Indispensable pour Chrome pour obtenir les bytes
      );
      return result;
    } catch (e) {
      debugPrint("Erreur lors de la sélection du fichier: $e");
      return null;
    }
  }

  /// Ouvre un fichier (Mobile uniquement)
  static Future<void> openFile(String path) async {
    if (kIsWeb) {
      debugPrint("L'ouverture directe par chemin n'est pas possible sur le Web.");
      return; 
    }
    try {
      await OpenFilex.open(path);
    } catch (e) {
      debugPrint("Erreur lors de l'ouverture du fichier: $e");
    }
  }

  /// Sauvegarde des octets en fichier temporaire et l'ouvre (Mobile seulement)
  static Future<void> openFromBytes(Uint8List bytes, String fileName) async {
    if (kIsWeb) {
      debugPrint("Traitement des octets sur le Web...");
      // Sur le Web, on pourrait déclencher un téléchargement ici si nécessaire
      return;
    }
    try {
      final tempDir = await getTemporaryDirectory();
      final file = await File('${tempDir.path}/$fileName').create();
      await file.writeAsBytes(bytes);
      await openFile(file.path);
    } catch (e) {
       debugPrint("Erreur lors de la sauvegarde/ouverture des octets: $e");
    }
  }
}
