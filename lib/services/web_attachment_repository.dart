import 'dart:typed_data';

import 'package:ecclesiaste/models/attachment_model.dart';
import 'package:hive/hive.dart';

import 'attachment_repository.dart';

/// Implémentation du [AttachmentRepository] pour la plateforme Web.
///
/// Elle sauvegarde les données binaires (Uint8List) directement dans une boîte Hive
/// dédiée ('attachment_data_box'). Le `relativePath` de l'objet [Attachment]
/// est utilisé ici comme une simple clé (key) dans la base de données.
class WebAttachmentRepository implements AttachmentRepository {
  final String _boxName = 'attachment_data_box';

  Future<Box<Uint8List>> _getBox() async {
    return Hive.openBox<Uint8List>(_boxName);
  }

  @override
  Future<String> saveAttachmentData(Uint8List data, String fileName) async {
    final box = await _getBox();
    final key = '${DateTime.now().millisecondsSinceEpoch}_$fileName';
    await box.put(key, data);
    return key; // Le `relativePath` devient la clé dans Hive
  }

  @override
  Future<Uint8List?> loadAttachmentData(Attachment attachment) async {
    final box = await _getBox();
    return box.get(attachment.relativePath);
  }

  @override
  Future<void> deleteAttachmentData(Attachment attachment) async {
    final box = await _getBox();
    await box.delete(attachment.relativePath);
  }
}
