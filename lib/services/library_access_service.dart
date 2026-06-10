import 'package:hive/hive.dart';
import '../models/library_document.dart';
import '../models/hierarchy_models.dart';

class LibraryAccessService {

  static UserCategory _resolveCategory(Map<String, dynamic> user) {
    final role = user['role']?.toString() ?? 'MEMBRE';
    final roleLabel = user['role_label']?.toString() ?? '';
    if (role == 'SUPER_ADMIN' || role == 'RESPONSABLE') return UserCategory.responsable;
    if (roleLabel.contains('Apôtre') ||
        roleLabel.contains('Ministre') ||
        roleLabel.contains('Prêtre') ||
        roleLabel.contains('Berger') ||
        roleLabel.contains('Évêque') ||
        roleLabel.contains('Ancien') ||
        roleLabel.contains('Evangéliste')) {
      return UserCategory.ministre;
    }
    return UserCategory.membre;
  }

  static CommissionType _resolveCommission(Map<String, dynamic> user) {
    final userCommissions = (user['commissions'] as List?)?.map((e) => e.toString()).toList() ?? [];
    if (userCommissions.contains('ECODIM')) return CommissionType.ecodim;
    if (userCommissions.contains('CONFIRMATION')) return CommissionType.confirmation;
    if (userCommissions.contains('JEUNESSE')) return CommissionType.jeunesse;
    if (userCommissions.contains('MUSIQUE')) return CommissionType.musique;
    return CommissionType.none;
  }

  static EntityLevel _resolveLevel(Map<String, dynamic> user) {
    final level = user['entity_level']?.toString() ?? 'COMMUNAUTE';
    switch (level.toUpperCase()) {
      case 'DISTRICT': return EntityLevel.district;
      case 'CHAMP': return EntityLevel.champ;
      case 'TERRITORIALE': return EntityLevel.territoriale;
      case 'INTERNATIONALE': return EntityLevel.internationale;
      default: return EntityLevel.communaute;
    }
  }

  static bool canAccess(LibraryDocument doc, Map<String, dynamic> user) {
    final isSuperAdmin = (user['role']?.toString() ?? '') == 'SUPER_ADMIN';
    final category = _resolveCategory(user);
    final level = _resolveLevel(user);
    final commission = _resolveCommission(user);
    return doc.canAccess(category, level, commission, isSuperAdmin: isSuperAdmin);
  }

  static List<LibraryDocument> getAccessibleDocuments(Map<String, dynamic> user) {
    final box = Hive.box<LibraryDocument>('library_box');
    return box.values.where((doc) => canAccess(doc, user)).toList()
      ..sort((a, b) => a.title.compareTo(b.title));
  }

  static String getAccessDeniedMessage(LibraryDocument doc) {
    if (doc.allowedCategories.contains(UserCategory.ministre) &&
        !doc.allowedCategories.contains(UserCategory.membre)) {
      return '🔒 Ce document est réservé aux ministres ordonnés.';
    }
    if (doc.allowedCommissions.isNotEmpty && doc.allowedCommissions.first != CommissionType.none) {
      final names = doc.allowedCommissions.map((c) => c.name).join(', ');
      return '🔒 Ce document est réservé aux membres de: $names.';
    }
    return 'Accès refusé.';
  }
}
