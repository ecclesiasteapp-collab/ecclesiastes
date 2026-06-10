import 'package:hive/hive.dart';
import 'hierarchy_models.dart';

part 'library_document.g.dart';

@HiveType(typeId: 10)
enum UserCategory {
  @HiveField(0) membre,
  @HiveField(1) ministre,
  @HiveField(2) responsable,
}

@HiveType(typeId: 13)
enum DocumentType {
  @HiveField(0) penseesDirectrices,
  @HiveField(1) manuelCommission,
  @HiveField(2) programmeApostolique,
  @HiveField(3) programmeCommission,
  @HiveField(4) directives,
  @HiveField(5) cantiques,
  @HiveField(6) formulaire,
  @HiveField(7) liturgie,
  @HiveField(8) formation,
  @HiveField(9) autre,
}

@HiveType(typeId: 14)
class LibraryDocument extends HiveObject {
  @HiveField(0) late String id;
  @HiveField(1) late String title;
  @HiveField(2) late String description;
  @HiveField(3) late DocumentType type;
  @HiveField(4) late String filePath;
  @HiveField(5) late int fileSize;
  @HiveField(6) late DateTime uploadDate;
  
  @HiveField(7) late List<UserCategory> allowedCategories;
  @HiveField(8) late List<EntityLevel> allowedLevels;
  @HiveField(9) late List<CommissionType> allowedCommissions;
  
  @HiveField(10) String? author;
  @HiveField(11) String? version;
  @HiveField(12) bool isConfidential;
  @HiveField(13) DateTime? expiryDate;
  
  LibraryDocument({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    required this.filePath,
    required this.fileSize,
    required this.allowedCategories,
    required this.allowedLevels,
    required this.allowedCommissions,
    DateTime? uploadDate,
    this.author,
    this.version,
    this.isConfidential = false,
    this.expiryDate,
  }) : uploadDate = uploadDate ?? DateTime.now();
  
  bool canAccess(UserCategory category, EntityLevel level, CommissionType commission, {bool isSuperAdmin = false}) {
    if (isSuperAdmin) return true;
    
    if (!allowedCategories.contains(category)) return false;
    if (!allowedLevels.contains(level)) return false;
    if (allowedCommissions.isNotEmpty && allowedCommissions.first != CommissionType.none && !allowedCommissions.contains(commission)) {
      return false;
    }
    
    return true;
  }
}
