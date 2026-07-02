import 'package:hive/hive.dart';
import '../models/library_document.dart';
import '../models/library_resource.dart';
import '../models/hierarchy_models.dart';

class LibraryService {
  static final LibraryService _instance = LibraryService._internal();
  factory LibraryService() => _instance;
  LibraryService._internal();

  static const String _boxName = 'library_resources';

  Future<Box<LibraryResource>> get _box async =>
      Hive.openBox<LibraryResource>(_boxName);

  Future<void> saveResource(LibraryResource resource) async {
    final box = await _box;
    await box.put(resource.id, resource);
  }

  Future<List<LibraryResource>> getResourcesByCategory(
      LibraryCategory category) async {
    final box = await _box;
    return box.values.where((r) => r.category == category).toList();
  }

  Future<List<LibraryResource>> getProgramsByLevel(EntityLevel level) async {
    final box = await _box;
    return box.values
        .where(
            (r) => r.category == LibraryCategory.programmes && r.level == level)
        .toList();
  }

  Future<LibraryResource?> getResourceById(String id) async {
    final box = await _box;
    return box.get(id);
  }

  static Box<LibraryDocument>? _libraryBox() {
    if (Hive.isBoxOpen('library_box')) {
      return Hive.box<LibraryDocument>('library_box');
    }
    return null;
  }

  static Map<String, int> getStatistics({
    required UserCategory category,
    required EntityLevel level,
    required CommissionType commission,
    bool isSuperAdmin = false,
  }) {
    final box = _libraryBox();
    if (box == null) {
      return {
        'total': 0,
        'penseesDirectrices': 0,
        'manuels': 0,
        'programmes': 0,
      };
    }

    final docs = box.values.where((doc) =>
        doc.canAccess(category, level, commission, isSuperAdmin: isSuperAdmin));

    return {
      'total': docs.length,
      'penseesDirectrices': docs
          .where((doc) => doc.type == DocumentType.penseesDirectrices)
          .length,
      'manuels':
          docs.where((doc) => doc.type == DocumentType.manuelCommission).length,
      'programmes': docs
          .where((doc) =>
              doc.type == DocumentType.programmeApostolique ||
              doc.type == DocumentType.programmeCommission)
          .length,
    };
  }

  static List<LibraryDocument> search({
    required String query,
    required UserCategory category,
    required EntityLevel level,
    required CommissionType commission,
    bool isSuperAdmin = false,
  }) {
    final box = _libraryBox();
    if (box == null) return [];

    final normalizedQuery = query.toLowerCase();
    return box.values.where((doc) {
      final matchesQuery = doc.title.toLowerCase().contains(normalizedQuery) ||
          doc.description.toLowerCase().contains(normalizedQuery) ||
          doc.filePath.toLowerCase().contains(normalizedQuery);
      return matchesQuery &&
          doc.canAccess(category, level, commission,
              isSuperAdmin: isSuperAdmin);
    }).toList();
  }

  static List<LibraryDocument> getAccessibleDocuments({
    required UserCategory category,
    required EntityLevel level,
    required CommissionType commission,
    bool isSuperAdmin = false,
  }) {
    final box = _libraryBox();
    if (box == null) return [];

    return box.values
        .where((doc) => doc.canAccess(category, level, commission,
            isSuperAdmin: isSuperAdmin))
        .toList();
  }

  static List<LibraryDocument> getByType({
    required DocumentType type,
    required UserCategory category,
    required EntityLevel level,
    required CommissionType commission,
    bool isSuperAdmin = false,
  }) {
    final box = _libraryBox();
    if (box == null) return [];

    return box.values.where((doc) {
      return doc.type == type &&
          doc.canAccess(category, level, commission,
              isSuperAdmin: isSuperAdmin);
    }).toList();
  }
}

