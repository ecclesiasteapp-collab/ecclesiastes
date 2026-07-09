import 'dart:typed_data';

import 'package:ecclesiaste/models/attachment_model.dart';

/// Interface abstraite pour la gestion du stockage des pièces jointes.
///
/// Cette couche d'abstraction permet de découpler la logique de l'application
/// de l'implémentation concrète du stockage, qui peut varier entre le mobile
/// (système de fichiers) et le web (IndexedDB/Hive, Blob, etc.).
abstract class AttachmentRepository {
  /// Sauvegarde les données brutes d'un fichier et retourne le chemin ou l'identifiant de stockage.
  /// Le `fileName` est utilisé pour générer un chemin unique.
  Future<String> saveAttachmentData(Uint8List data, String fileName);

  /// Charge les données brutes d'une pièce jointe à partir de son chemin/identifiant.
  Future<Uint8List?> loadAttachmentData(Attachment attachment);

  /// Supprime les données d'une pièce jointe.
  Future<void> deleteAttachmentData(Attachment attachment);
}
