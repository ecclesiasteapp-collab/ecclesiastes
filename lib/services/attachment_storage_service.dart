import 'dart:typed_data';

import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';
import '../models/attachment_model.dart';
import 'database_service.dart';
import 'file_storage_service.dart';

class AttachmentStorageService {
  static Future<Attachment> saveAttachment(
    String fileName,
    String mimeType,
    Uint8List fileBytes,
  ) async {
    final box = await DatabaseService.openBox<Attachment>(DatabaseService.attachmentsBoxName);
    // Déterminez l'extension du fichier
    // Sauvegardez le fichier sur le système de fichiers et obtenez le chemin relatif
    final relativePath = await FileStorageService.saveFile(fileBytes, fileName);

    final attachment = Attachment(
      id: const Uuid().v4(),
      fileName: fileName,
      mimeType: mimeType,
      relativePath: relativePath, // <-- Nouveau: stocke le chemin relatif
      fileSize: fileBytes.length,
      fileExtension: fileName.contains('.') ? fileName.split('.').last : null,
    );
    await box.put(attachment.id, attachment);
    return attachment;
  }

  /// Récupère un attachment par ID
  static Future<Attachment?> getAttachment(String id) async {
    final box = await DatabaseService.openBox<Attachment>(DatabaseService.attachmentsBoxName);
    return box.get(id);
  }

  Future<Uint8List?> getAttachmentData(String attachmentId) async {
    final box = await DatabaseService.openBox<Attachment>(DatabaseService.attachmentsBoxName);
    final attachment = box.get(attachmentId);
    if (attachment == null) return null;
    return await FileStorageService.readFile(attachment.relativePath);
  }

  /// Supprime un attachment par ID
  static Future<void> deleteAttachment(String id) async {
    final box = await DatabaseService.openBox<Attachment>(DatabaseService.attachmentsBoxName);
    final attachment = box.get(id);
    if (attachment != null) {
      await FileStorageService.deleteFile(attachment.relativePath); // Supprime le fichier physique
      await attachment.delete(); // Supprime l'entrée Hive
    }
  }

  /// Liste tous les attachments
  static Future<List<Attachment>> getAllAttachments() async {
    final box = await DatabaseService.openBox<Attachment>(DatabaseService.attachmentsBoxName);
    return box.values.toList();
  }

  static Future<double> getTotalAttachmentSizeInMB() async {
    final attachments = await getAllAttachments();
    final totalBytes = attachments.fold<int>(0, (sum, item) => sum + item.fileSize);
    return totalBytes / (1024 * 1024);
  }
}

