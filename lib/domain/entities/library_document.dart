import 'ecclesiastical_entity.dart';

enum DocumentType { teaching, circular, report, manual }

class LibraryDocument {
  final String id;
  final String title;
  final String description;
  final DocumentType type;
  final String url;
  
  // Contrôle d'accès
  final List<String> allowedRoles; // Ex: ["PASTOR", "DISTRICT_SUPERVISOR"]
  final EntityLevel minimumLevel;  // Niveau hiérarchique min requis
  final String? tenantId;          // Isolation par territoire

  final DateTime createdAt;

  LibraryDocument({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    required this.url,
    required this.allowedRoles,
    required this.minimumLevel,
    this.tenantId,
    required this.createdAt,
  });
}
