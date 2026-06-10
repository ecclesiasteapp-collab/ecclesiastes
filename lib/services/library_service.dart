import 'package:hive/hive.dart';
import '../models/library_document.dart';
import '../models/hierarchy_models.dart';

class LibraryService {
  static const String _boxName = 'library_box';
  
  static Box<LibraryDocument> get _box => Hive.box<LibraryDocument>(_boxName);
  
  static List<LibraryDocument> getAccessibleDocuments({
    required UserCategory category,
    required EntityLevel level,
    required CommissionType commission,
    bool isSuperAdmin = false,
  }) {
    return _box.values.where((doc) {
      return doc.canAccess(category, level, commission, isSuperAdmin: isSuperAdmin);
    }).toList()
      ..sort((a, b) => b.uploadDate.compareTo(a.uploadDate));
  }
  
  static List<LibraryDocument> getByType({
    required DocumentType type,
    required UserCategory category,
    required EntityLevel level,
    required CommissionType commission,
    bool isSuperAdmin = false,
  }) {
    return getAccessibleDocuments(
      category: category,
      level: level,
      commission: commission,
      isSuperAdmin: isSuperAdmin,
    ).where((doc) => doc.type == type).toList();
  }
  
  static List<LibraryDocument> getByCommission({
    required CommissionType commission,
    required UserCategory category,
    required EntityLevel level,
    bool isSuperAdmin = false,
  }) {
    return getAccessibleDocuments(
      category: category,
      level: level,
      commission: commission,
      isSuperAdmin: isSuperAdmin,
    ).where((doc) => doc.allowedCommissions.contains(commission)).toList();
  }
  
  static List<LibraryDocument> search({
    required String query,
    required UserCategory category,
    required EntityLevel level,
    required CommissionType commission,
    bool isSuperAdmin = false,
  }) {
    final lowerQuery = query.toLowerCase();
    return getAccessibleDocuments(
      category: category,
      level: level,
      commission: commission,
      isSuperAdmin: isSuperAdmin,
    ).where((doc) {
      return doc.title.toLowerCase().contains(lowerQuery) ||
             doc.description.toLowerCase().contains(lowerQuery);
    }).toList();
  }
  
  static Map<String, int> getStatistics({
    required UserCategory category,
    required EntityLevel level,
    required CommissionType commission,
    bool isSuperAdmin = false,
  }) {
    final docs = getAccessibleDocuments(
      category: category,
      level: level,
      commission: commission,
      isSuperAdmin: isSuperAdmin,
    );
    
    return {
      'total': docs.length,
      'penseesDirectrices': docs.where((d) => d.type == DocumentType.penseesDirectrices).length,
      'manuels': docs.where((d) => d.type == DocumentType.manuelCommission).length,
      'programmes': docs.where((d) => d.type == DocumentType.programmeCommission || d.type == DocumentType.programmeApostolique).length,
      'formulaires': docs.where((d) => d.type == DocumentType.formulaire).length,
      'totalSize': docs.fold<int>(0, (sum, doc) => sum + doc.fileSize),
    };
  }
}
