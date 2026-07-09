import 'dart:io';
import 'dart:typed_data';

import 'package:ecclesiaste/models/attachment_model.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:ecclesiaste/services/logging_service.dart';
import 'package:uuid/uuid.dart';

import 'attachment_repository.dart';

/// Implémentation du [AttachmentRepository] pour les plateformes mobiles (Android/iOS).
///
/// Elle sauvegarde les fichiers dans le répertoire des documents de l'application
/// et utilise le chemin relatif comme identifiant.
class MobileAttachmentRepository implements AttachmentRepository {
  @override
  Future<String> saveAttachmentData(Uint8List data, String fileName) async {
    final appDir = await getApplicationDocumentsDirectory();
    final extension = p.extension(fileName);
    final uniqueFileName = '${const Uuid().v4()}$extension';
    final relativePath = p.join('attachments', uniqueFileName);
    final file = File(p.join(appDir.path, relativePath));

    await file.parent.create(recursive: true);
    await file.writeAsBytes(data);

    return relativePath;
  }

  @override
  Future<Uint8List?> loadAttachmentData(Attachment attachment) async {
    final appDir = await getApplicationDocumentsDirectory();
    final file = File(p.join(appDir.path, attachment.relativePath));
    return await file.exists() ? file.readAsBytes() : null;
  }

  @override
  Future<void> deleteAttachmentData(Attachment attachment) async {
    try {
      final appDir = await getApplicationDocumentsDirectory();
      final file = File(p.join(appDir.path, attachment.relativePath));

      if (await file.exists()) {
        await file.delete();
      }
    } catch (e) {
      // Idéalement, logger l'erreur avec un service de logging
      LoggingService.error('Error deleting attachment file: $e');
    }
  }
}
