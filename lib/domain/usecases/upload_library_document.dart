import '../entities/library_document.dart';
import '../entities/ecclesiastical_entity.dart';
import '../repositories/library_repository.dart';

class UploadLibraryDocument {
  final LibraryRepository repository;

  UploadLibraryDocument(this.repository);

  Future<void> execute({
    required String title,
    required String description,
    required DocumentType type,
    required String fileUrl,
    required List<String> allowedRoles,
    required EntityLevel minimumLevel,
    String? tenantId,
  }) async {
    final doc = LibraryDocument(
      id: "DOC_${DateTime.now().millisecondsSinceEpoch}",
      title: title,
      description: description,
      type: type,
      url: fileUrl,
      allowedRoles: allowedRoles,
      minimumLevel: minimumLevel,
      tenantId: tenantId,
      createdAt: DateTime.now(),
    );

    await repository.saveDocument(doc);
  }
}
