import '../models/hierarchy_models.dart';
import 'auth_service.dart';

class AccessControlService {
  /// Vérifie si l'utilisateur peut accéder à une entité spécifique
  static bool canAccessEntity(String targetEntityId, EntityLevel targetLevel) {
    final user = AuthService.currentUser;
    if (user == null) return false;

    // Super Admin a accès à tout
    if (user.role == UserRole.superAdmin || user.role == UserRole.apotrePatriarche) {
      return true;
    }

    // Logique de filtrage par EntityLevel
    final userLevel = user.entityLevel ?? EntityLevel.communaute;

    if (userLevel.index > targetLevel.index) {
      // Un niveau "Communauté" (index 0) ne peut pas voir un "District" (index 1)
      return false;
    }

    // Vérification de l'appartenance à la branche (entityId)
    if (user.entityId != 'ROOT' && user.entityId != targetEntityId) {
      return false;
    }

    return true;
  }

  /// Filtre une liste d'objets (Rapports, Membres) selon les droits de l'utilisateur
  static List<T> filterByHierarchy<T>(List<T> items, String Function(T) getEntityId, EntityLevel Function(T) getLevel) {
    return items.where((item) => canAccessEntity(getEntityId(item), getLevel(item))).toList();
  }

  /// Vérifie si l'utilisateur peut valider un rapport
  static bool canValidate(EntityLevel reportLevel) {
    final user = AuthService.currentUser;
    if (user == null) return false;
    if (user.role == UserRole.superAdmin) return true;

    final userLevel = user.entityLevel ?? EntityLevel.communaute;

    // Règle d'or : On valide uniquement le niveau directement en dessous ou son propre niveau si on est responsable
    return userLevel.index >= reportLevel.index;
  }
}

