import 'dart:io';
import 'dart:typed_data';
import 'package:path_provider/path_provider.dart';
import 'package:ecclesiastes/services/logging_service.dart';

class FileStorageService {
  static Future<String> _getAppDirectory() async {
    final directory = await getApplicationDocumentsDirectory();
    final appDirectory = Directory('${directory.path}/ecclesiaste_files');
    if (!await appDirectory.exists()) {
      await appDirectory.create(recursive: true);
    }
    return appDirectory.path;
  }

  static Future<String> saveFile(Uint8List bytes, String fileName) async {
    try {
      final appDirectoryPath = await _getAppDirectory();
      final filePath = '$appDirectoryPath/$fileName';
      final file = File(filePath);
      await file.writeAsBytes(bytes);
      return filePath; // Retourne le chemin absolu
    } catch (e, stack) {
      LoggingService.error('Erreur lors de la sauvegarde du fichier', e, stack);
      rethrow;
    }
  }

  static Future<Uint8List?> readFile(String relativePath) async {
    try {
      final file = File(relativePath);
      if (await file.exists()) {
        return await file.readAsBytes();
      }
      return null;
    } catch (e, stack) {
      LoggingService.error('Erreur lors de la lecture du fichier', e, stack);
      return null;
    }
  }

  static Future<void> deleteFile(String relativePath) async {
    try {
      final file = File(relativePath);
      if (await file.exists()) {
        await file.delete();
      }
    } catch (e, stack) {
      LoggingService.error('Erreur lors de la suppression du fichier', e, stack);
      rethrow;
    }
  }

  static Future<String> saveSignature(String reportId, String signatureBase64) async {
    try {
      final bytes = Uri.parse(signatureBase64).data!.contentAsBytes();
      final fileName = 'signature_$reportId.png';
      return await saveFile(bytes, fileName);
    } catch (e, stack) {
      LoggingService.error('Erreur lors de la sauvegarde de la signature', e, stack);
      rethrow;
    }
  }
}
