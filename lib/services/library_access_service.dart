import 'package:hive/hive.dart';
import 'package:ecclesiaste/models/hierarchy_models.dart';
import 'package:ecclesiaste/models/user.dart';
import '../models/library_document.dart';

class LibraryAccessService {
  static bool canAccess(LibraryDocument doc, User user) {
    if (user.role == UserRole.superAdmin) return true;

    // Mapping du rôle UserRole vers UserCategory (pour la bibliothèque)
    UserCategory category = UserCategory.membre;
    if (user.role == UserRole.apotrePatriarche ||
        user.role == UserRole.apotreDistrict ||
        user.role == UserRole.apotreResponsable ||
        user.role == UserRole.apotre ||
        user.role == UserRole.eveque ||
        user.role == UserRole.ancien) {
      category = UserCategory.responsable;
    } else if (user.role != UserRole.membre) {
      category = UserCategory.ministre;
    }

    // EntityLevel est déjà un enum dans User
    final EntityLevel level = user.entityLevel ?? EntityLevel.communaute;

    // CommissionType est déjà un enum dans User
    final CommissionType commission = user.commissionType ?? CommissionType.none;

    return doc.canAccess(
      category,
      level,
      commission,
      isSuperAdmin: user.role == UserRole.superAdmin,
    );
  }

  static List<LibraryDocument> getAccessibleDocuments(User user) {
    final box = Hive.box<LibraryDocument>('library_box');
    return box.values.where((doc) => canAccess(doc, user)).toList()
      ..sort((a, b) => a.title.compareTo(b.title));
  }

  static String getAccessDeniedMessage(LibraryDocument doc) {
    if (doc.allowedCategories.contains(UserCategory.ministre) &&
        !doc.allowedCategories.contains(UserCategory.membre)) {
      return '🔒 Ce document est réservé aux ministres ordonnés.';
    }
    if (doc.allowedCommissions.isNotEmpty &&
        doc.allowedCommissions.first != CommissionType.none) {
      final names = doc.allowedCommissions.map((c) => c.name).join(', ');
      return '🔒 Ce document est réservé aux membres de: $names.';
    }
    return 'Accès refusé.';
  }
}

