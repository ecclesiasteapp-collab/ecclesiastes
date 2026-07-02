import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/attachment_repository.dart';
import '../services/mobile_attachment_repository.dart';
import '../services/web_attachment_repository.dart';

/// Fournit l'implémentation appropriée du [AttachmentRepository] en fonction de la plateforme.
///
/// Sur mobile, il utilise [MobileAttachmentRepository] qui sauvegarde les fichiers sur le disque.
/// Sur le web, il utilise [WebAttachmentRepository] qui sauvegarde les données dans Hive/IndexedDB.
final attachmentRepositoryProvider = Provider<AttachmentRepository>((ref) {
  if (kIsWeb) {
    return WebAttachmentRepository();
  }
  return MobileAttachmentRepository();
});
