import 'package:ecclesiastes/models/hierarchy_models.dart';
import 'package:ecclesiastes/services/database_helper.dart';
import 'package:ecclesiastes/services/auth_service.dart';

class NominationService {
  NominationService._();

  /// Vérifie si l'utilisateur actuel peut nommer quelqu'un à un certain niveau
  static bool canNominate(EntityLevel targetLevel) {
    final user = AuthService.currentUser;
    if (user == null || user.status == 'suspended') return false;
    if (user.role == UserRole.superAdmin) return true;

    // Vérification des délégations explicites
    if (user.delegatedPermissions?.contains('nominate_${targetLevel.name}') ?? false) {
      return true;
    }

    // Règles hiérarchiques strictes
    switch (user.entityLevel) {
      case EntityLevel.internationale:
        return targetLevel == EntityLevel.territoriale;
      case EntityLevel.territoriale:
        return targetLevel == EntityLevel.district;
      case EntityLevel.champ:
        return targetLevel == EntityLevel.communaute;
      default:
        return false;
    }
  }

  /// Effectue une nomination
  static Future<void> nominate({
    required String targetUserId,
    required EntityLevel level,
    required String entityId,
    bool isAdjoint = false,
    bool isInterim = false,
  }) async {
    final targetUserMap = await DatabaseHelper.instance.getUtilisateurByIdentifiant(targetUserId);
    if (targetUserMap == null) throw Exception('Utilisateur cible non trouvé');

    final updatedUser = Map<String, dynamic>.from(targetUserMap);
    updatedUser['entity_level'] = level.name;
    updatedUser['entity_id'] = entityId;
    updatedUser['entity_role'] = isAdjoint ? 'suppleant' : 'responsable';
    updatedUser['is_interim'] = isInterim;
    
    await DatabaseHelper.instance.updateUtilisateur(targetUserMap['id'], updatedUser);
  }

  /// Délègue la compétence de nomination
  static Future<void> delegateNomination({
    required String fromUserId,
    required String toUserId,
    required EntityLevel targetLevel,
  }) async {
    final toUserMap = await DatabaseHelper.instance.getUtilisateurByIdentifiant(toUserId);
    if (toUserMap == null) throw Exception('Utilisateur cible non trouvé');

    final updatedUser = Map<String, dynamic>.from(toUserMap);
    final List<String> permissions = List<String>.from(updatedUser['delegated_permissions'] ?? []);
    
    final perm = 'nominate_${targetLevel.name}';
    if (!permissions.contains(perm)) {
      permissions.add(perm);
    }
    
    updatedUser['delegated_permissions'] = permissions;
    await DatabaseHelper.instance.updateUtilisateur(toUserMap['id'], updatedUser);
  }
}

