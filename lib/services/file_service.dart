import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:url_launcher/url_launcher.dart';
import 'file_platform_helper.dart';

class FileService {
  /// Ouvre un sélecteur de fichiers compatible Mobile et Web
  static Future<FilePickerResult?> pickFile() async {
    try {
      final FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'jpg', 'png', 'doc', 'docx', 'xlsx', 'xls'],
        withData: kIsWeb,
      );
      return result;
    } catch (e) {
      debugPrint('Erreur lors de la sélection du fichier: $e');
      return null;
    }
  }

  /// Ouvre un fichier (Mobile et Web)
  static Future<void> openFile(String path) async {
    if (kIsWeb) {
      debugPrint('Ouverture sur le Web via url_launcher: $path');
      try {
        final uri = Uri.parse(path.startsWith('assets/') ? path : 'assets/$path');
        if (await canLaunchUrl(uri)) {
          await launchUrl(uri, mode: LaunchMode.externalApplication);
        } else {
          debugPrint("Impossible de lancer l'URL: $uri");
        }
      } catch (e) {
        debugPrint("Erreur lors de l'ouverture du lien sur le Web: $e");
      }
      return; 
    }
    try {
      await openPlatformFile(path);
    } catch (e) {
      debugPrint("Erreur lors de l'ouverture du fichier: $e");
    }
  }

  /// Sauvegarde des octets en fichier temporaire et l'ouvre (Mobile seulement)
  static Future<void> openFromBytes(Uint8List bytes, String fileName) async {
    if (kIsWeb) {
      debugPrint('Traitement des octets sur le Web...');
      return;
    }
    try {
      await openBytesAsTemporaryFile(bytes, fileName);
    } catch (e) {
       debugPrint('Erreur lors de la sauvegarde/ouverture des octets: $e');
    }
  }
}

