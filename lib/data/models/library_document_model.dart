import 'package:hive/hive.dart';
import '../../domain/entities/library_document.dart';
import '../../domain/entities/ecclesiastical_entity.dart';

part 'library_document_model.g.dart';

@HiveType(typeId: 255)
class LibraryDocumentModel extends HiveObject {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String title;
  @HiveField(2)
  final String description;
  @HiveField(3)
  final int typeIndex;
  @HiveField(4)
  final String url;
  @HiveField(5)
  final List<String> allowedRoles;
  @HiveField(6)
  final int minimumLevelIndex;
  @HiveField(7)
  final String? tenantId;
  @HiveField(8)
  final DateTime createdAt;

  LibraryDocumentModel({
    required this.id,
    required this.title,
    required this.description,
    required this.typeIndex,
    required this.url,
    required this.allowedRoles,
    required this.minimumLevelIndex,
    this.tenantId,
    required this.createdAt,
  });

  factory LibraryDocumentModel.fromEntity(LibraryDocument doc) {
    return LibraryDocumentModel(
      id: doc.id,
      title: doc.title,
      description: doc.description,
      typeIndex: doc.type.index,
      url: doc.url,
      allowedRoles: doc.allowedRoles,
      minimumLevelIndex: doc.minimumLevel.index,
      tenantId: doc.tenantId,
      createdAt: doc.createdAt,
    );
  }

  LibraryDocument toEntity() {
    return LibraryDocument(
      id: id,
      title: title,
      description: description,
      type: DocumentType.values[typeIndex],
      url: url,
      allowedRoles: allowedRoles,
      minimumLevel: EntityLevel.values[minimumLevelIndex],
      tenantId: tenantId,
      createdAt: createdAt,
    );
  }
}
