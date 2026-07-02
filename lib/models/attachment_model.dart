import 'package:hive/hive.dart';
import 'dart:typed_data';

part 'attachment_model.g.dart';

@HiveType(typeId: 103) // TypeId unique dans le projet
class Attachment extends HiveObject {
  Uint8List? _fileData;

  @HiveField(0)
  late String id;

  @HiveField(1)
  late String fileName;

  @HiveField(2)
  late String mimeType; // ex: 'image/jpeg', 'text/csv', 'application/pdf'

  @HiveField(3)
  late String relativePath; // Chemin relatif du fichier sur le système de fichiers

  @HiveField(5)
  late int fileSize; // Taille en octets

  @HiveField(6)
  String? fileExtension; // Extension du fichier

  @HiveField(7)
  String? thumbnailUrl; // URL de la miniature pour les images

  // Getters pour la taille du fichier en KB, MB, GB
  double get fileSizeInKB => fileSize / 1024;
  double get fileSizeInMB => fileSizeInKB / 1024;
  double get fileSizeInGB => fileSizeInMB / 1024;

  // Getter pour le type MIME simplifié
  String get simpleMimeType {
    if (mimeType.startsWith("image/")) return "image";
    if (mimeType.startsWith("video/")) return "video";
    if (mimeType.startsWith("audio/")) return "audio";
    if (mimeType == "application/pdf") return "pdf";
    return "document";
  }

  Uint8List? get rawFileData => _fileData;
  Uint8List get fileData => _fileData ?? Uint8List(0);
  set fileData(Uint8List? value) {
    _fileData = value;
    if (value != null && fileSize == 0) {
      fileSize = value.length;
    }
  }

  Attachment({
    required this.id,
    required this.fileName,
    required this.mimeType,
    this.relativePath = '',
    int? fileSize,
    this.fileExtension,
    this.thumbnailUrl,
    Uint8List? fileData,
  }) : fileSize = fileSize ?? fileData?.length ?? 0,
       _fileData = fileData;

  bool get isImage => mimeType.startsWith('image/');

  bool get isDocument => !isImage;


}

