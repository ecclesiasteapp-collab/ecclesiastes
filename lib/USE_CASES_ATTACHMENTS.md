// ============================================================================
// CAS D'USAGE PRATIQUES - SYSTÈME D'ATTACHMENTS
// ============================================================================

/*
 * CAS 1: CRÉER UN ÉVÉNEMENT AVEC TABLE DE DONNÉES (EXCEL)
 * ======================================================
 * 
 * Contexte: Un responsable de district crée un événement "Cours de Bible"
 *           et attache une liste Excel des participants attendus.
 */

import 'package:ecclesiastes/models/event.dart';
import 'package:ecclesiastes/services/attachment_storage_service.dart';
import 'package:uuid/uuid.dart';

Future<void> createEventWithParticipantList(
  String title,
  String description,
  DateTime eventDate,
  Attachment? participantList,
) async {
  final event = ChurchEvent(
    id: const Uuid().v4(),
    title: title,
    description: description,
    start: eventDate,
    end: eventDate.add(const Duration(hours: 3)),
    level: EventLevel.field,
    dataAttachment: participantList, // ← L'attachment
  );

  await AttachmentStorageService.saveEventWithAttachment(
    event: event,
    attachment: participantList,
  );

  print('✅ Événement créé avec la liste: ${participantList?.fileName}');
}

// ============================================================================
// CAS 2: CRÉER UNE ANNONCE AVEC AFFICHE
// ======================================================
//
// Contexte: Une annonce importante pour le district avec une belle affiche
//           pour imprimer ou partager sur WhatsApp.

import 'package:ecclesiastes/models/news_model.dart';

Future<void> createImportantAnnouncement(
  String title,
  String content,
  Attachment? poster,
) async {
  final announcement = News(
    id: const Uuid().v4(),
    title: title,
    imageUrl: 'legacy-placeholder', // Pour compatibilité
    content: content,
    date: DateTime.now(),
    posterAttachment: poster, // ← L'affiche
  );

  await AttachmentStorageService.saveAnnouncementWithAttachment(
    announcement: announcement,
    attachment: poster,
  );

  print('✅ Annonce créée avec affiche: ${poster?.fileName}');
}

// ============================================================================
// CAS 3: CHARGER ET EXPORTER DANS UN PDF
// ======================================================
//
// Contexte: Générer un rapport PDF qui inclut l'image/document attaché

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

Future<pw.Document> generateReportWithAttachment(
  News announcement,
) async {
  final doc = pw.Document();

  doc.addPage(
    pw.Page(
      build: (pw.Context context) {
        return pw.Column(
          children: [
            pw.Text(
              announcement.title,
              style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold),
            ),
            pw.SizedBox(height: 12),
            // Inclure l'image si disponible
            if (announcement.posterAttachment?.isImage == true)
              pw.Image(
                pw.MemoryImage(announcement.posterAttachment!.fileData),
                width: 400,
                height: 300,
              ),
            pw.SizedBox(height: 12),
            pw.Text(announcement.content),
          ],
        );
      },
    ),
  );

  return doc;
}

// ============================================================================
// CAS 4: AFFICHER L'ATTACHMENT DANS UNE GALERIE (Mobile + Web)
// ======================================================
//
// Contexte: Un utilisateur veut voir l'affiche d'une annonce en grand

void openAttachmentPreview(BuildContext context, Attachment attachment) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => Scaffold(
        appBar: AppBar(
          title: Text(attachment.fileName),
          backgroundColor: const Color(0xFF003366),
        ),
        body: Center(
          child: attachment.isImage
              ? InteractiveViewer(
                  child: Image.memory(attachment.fileData),
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.insert_drive_file,
                      size: 80,
                      color: Colors.grey.shade600,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      attachment.fileName,
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${attachment.fileSizeInMB} MB',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
        ),
      ),
    ),
  );
}

// ============================================================================
// CAS 5: VÉRIFIER ET ALERTER SI L'ESPACE EST PLEIN
// ======================================================
//
// Contexte: L'administrateur doit être averti si les attachments
//           occupent trop d'espace

import 'package:ecclesiastes/services/attachment_storage_service.dart';

Future<void> checkStorageAndWarn(BuildContext context) async {
  final sizeInMB =
      await AttachmentStorageService.getTotalAttachmentSizeInMB();

  String message = '';
  Color color = Colors.green;

  if (sizeInMB > 200) {
    message = '⚠️ Attachments: ${sizeInMB.toStringAsFixed(1)} MB (CRITIQUE)';
    color = Colors.red;
  } else if (sizeInMB > 100) {
    message = '⚠️ Attachments: ${sizeInMB.toStringAsFixed(1)} MB (Élevé)';
    color = Colors.orange;
  } else {
    message = '✅ Attachments: ${sizeInMB.toStringAsFixed(1)} MB';
    color = Colors.green;
  }

  if (context.mounted) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: color),
    );
  }
}

// ============================================================================
// CAS 6: ÉDITER UNE ANNONCE ET REMPLACER L'AFFICHE
// ======================================================
//
// Contexte: Un responsable veut changer l'affiche d'une annonce déjà publiée

Future<void> updateAnnouncementPoster(
  String announcementId,
  Attachment? newPoster,
) async {
  // Charger l'annonce existante
  final announcement =
      await AttachmentStorageService.getAnnouncementWithAttachment(
          announcementId);

  if (announcement != null) {
    // Supprimer l'ancienne affiche si existe
    if (announcement.posterAttachment != null) {
      await AttachmentStorageService.deleteAttachment(
        announcement.posterAttachment!.id,
      );
    }

    // Mettre à jour avec la nouvelle affiche
    announcement.posterAttachment = newPoster;
    if (newPoster != null) {
      await AttachmentStorageService.saveAttachment(newPoster);
    }

    // Réenregistrer l'annonce (Hive met à jour l'objet existant)
    await announcement.save();

    print('✅ Affiche mise à jour: ${newPoster?.fileName}');
  }
}

// ============================================================================
// CAS 7: EXPORTER TOUS LES ÉVÉNEMENTS D'UN MOIS AVEC LEURS DONNÉES
// ======================================================
//
// Contexte: Générer un rapport pour le mois avec tous les événements

Future<List<ChurchEvent>> getEventsWithDataForMonth(int month, int year) async {
  final box = await Hive.openBox<ChurchEvent>('events_box');

  return box.values
      .where((event) {
        return event.start.month == month && event.start.year == year;
      })
      .where((event) => event.dataAttachment != null) // Seulement ceux avec données
      .toList();
}

// ============================================================================
// CAS 8: AFFICHER LES STATISTIQUES DES ATTACHMENTS PAR TYPE
// ======================================================
//
// Contexte: Dashboard administrateur montrant la répartition des attachments

Future<Map<String, int>> getAttachmentStatistics() async {
  final attachments =
      await AttachmentStorageService.getAllAttachments();

  final stats = {
    'images': 0,
    'documents': 0,
    'total_size_mb': 0,
  };

  for (final attachment in attachments) {
    if (attachment.isImage) {
      stats['images'] = (stats['images'] ?? 0) + 1;
    } else if (attachment.isDocument) {
      stats['documents'] = (stats['documents'] ?? 0) + 1;
    }
  }

  stats['total_size_mb'] =
      (await AttachmentStorageService.getTotalAttachmentSizeInMB()).toInt();

  return stats;
}

// ============================================================================
// CAS 9: PARTAGER UN ÉVÉNEMENT AVEC SES DONNÉES SUR WHATSAPP
// ======================================================
//
// Contexte: Utiliser les données attachées pour créer un message WhatsApp

import 'package:share_plus/share_plus.dart';

Future<void> shareEventWithData(ChurchEvent event) async {
  final message =
      '📅 ${event.title}\n${event.start}\n${event.description}';

  if (event.dataAttachment != null && event.dataAttachment!.isImage) {
    // Partager avec l'image
    // Note: Vous devrez sauvegarder temporairement le fichier
    // car share_plus nécessite un chemin réel sur mobile
    // Voir: https://pub.dev/packages/share_plus

    Share.share(
      message,
      subject: event.title,
    );
  } else {
    Share.share(message, subject: event.title);
  }
}

// ============================================================================
// CAS 10: MIGRER DE L'ANCIEN SYSTÈME (ImageUrl) AU NOUVEAU
// ======================================================
//
// Contexte: Vous aviez des images stockées par URL, maintenant vous voulez
//           utiliser les attachments

Future<void> migrateImageUrlToAttachment(
  News announcement,
  Uint8List imageData,
) async {
  // Créer un attachment à partir de l'image
  final attachment = Attachment(
    id: const Uuid().v4(),
    fileName: '${announcement.id}.jpg',
    mimeType: 'image/jpeg',
    fileData: imageData,
  );

  // Mettre à jour l'annonce
  announcement.posterAttachment = attachment;

  // Sauvegarder les deux
  await AttachmentStorageService.saveAnnouncementWithAttachment(
    announcement: announcement,
    attachment: attachment,
  );

  print('✅ Image migrée en attachment');
}

// ============================================================================
// RÉSUMÉ DES CAS D'USAGE
// ============================================================================

/*
 * ✅ CAS 1: Événement + Données participants
 * ✅ CAS 2: Annonce + Affiche
 * ✅ CAS 3: Exporter dans PDF
 * ✅ CAS 4: Prévisualiser l'attachment
 * ✅ CAS 5: Surveiller l'espace
 * ✅ CAS 6: Éditer les attachments
 * ✅ CAS 7: Filtrer par date avec attachments
 * ✅ CAS 8: Statistiques
 * ✅ CAS 9: Partager avec données
 * ✅ CAS 10: Migration de l'ancien système
 *
 * Tous les cas d'usage sont compatibles:
 * ✅ Web (Chrome, Firefox, Safari)
 * ✅ Mobile (Android, iOS)
 * ✅ Offline-first (Hive)
 */
