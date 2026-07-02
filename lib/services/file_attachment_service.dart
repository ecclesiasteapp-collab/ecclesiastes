import 'package:ecclesiastes/services/logging_service.dart';
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
import '../models/attachment_model.dart';
import 'package:uuid/uuid.dart';
import 'package:ecclesiastes/services/file_storage_service.dart';

class FileAttachmentService {
  static const Uuid _uuid = Uuid();
  static final ImagePicker _picker = ImagePicker();

  /// Sélectionne un fichier pour un Événement (Tables de données : CSV, XLSX, PDF)
  static Future<Attachment?> pickEventDataFile() async {
    return _pickFile(
      allowedExtensions: ['csv', 'xlsx', 'xls', 'pdf'],
    );
  }

  /// Sélectionne une affiche pour une Annonce (Image/Photo ou PDF)
  static Future<Attachment?> pickAnnouncementPoster() async {
    try {
      // Pour les images, on propose d'abord de choisir entre caméra et galerie
      final ImageSource? source = await _showImageSourceSelector();

      if (source != null) {
        final XFile? image = await _picker.pickImage(
          source: source,
          maxWidth: 1920,
          maxHeight: 1080,
          imageQuality: 85,
        );

        if (image != null) {
          final bytes = await image.readAsBytes();
          final savedPath = await FileStorageService.saveFile(bytes, image.name);
          return Attachment(
            id: _uuid.v4(),
            fileName: image.name,
            mimeType: 'image/jpeg',
            relativePath: savedPath,
            fileSize: bytes.length,
            fileExtension: image.name.split('.').last,
          );
        }
      } else {
        // Si aucune source image choisie, on tente le sélecteur de fichiers (pour le PDF par ex)
        return _pickFile(allowedExtensions: ['pdf', 'jpg', 'png', 'jpeg']);
      }
      return null;
    } catch (e) {
      LoggingService.error('Erreur sélection affiche', e);
      return null;
    }
  }

  static Future<ImageSource?> _showImageSourceSelector() async {
    // Cette partie est normalement gérée par l'UI, mais on simplifie ici
    // En production, il vaut mieux appeler cette méthode depuis un widget
    return null; // On laisse l'UI appeler picker directement si besoin
  }

  /// Sélectionne un fichier générique
  static Future<Attachment?> _pickFile({
    required List<String> allowedExtensions,
  }) async {
    try {
      final FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: allowedExtensions,
        withData: true,
      );

      if (result != null && result.files.isNotEmpty) {
        final file = result.files.first;
        final bytes = file.bytes;

        if (bytes == null) throw Exception('Lecture impossible');
        if (bytes.lengthInBytes > 5 * 1024 * 1024) throw Exception('Fichier > 5Mo');

        final savedPath = await FileStorageService.saveFile(bytes, file.name);
        return Attachment(
          id: _uuid.v4(),
          fileName: file.name,
          mimeType: _getMimeType(file.extension ?? ''),
          relativePath: savedPath,
          fileSize: bytes.length,
          fileExtension: file.extension,
        );
      }
      return null;
    } catch (e) {
      LoggingService.error('Erreur FilePicker', e);
      return null;
    }
  }

  static String _getMimeType(String extension) {
    const mimeTypes = {
      'pdf': 'application/pdf',
      'jpg': 'image/jpeg',
      'jpeg': 'image/jpeg',
      'png': 'image/png',
      'csv': 'text/csv',
    };
    return mimeTypes[extension.toLowerCase()] ?? 'application/octet-stream';
  }
}

