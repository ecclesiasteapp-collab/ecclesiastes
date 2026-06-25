import '../models/user.dart';
import '../models/hierarchy_models.dart';

enum AccessLevel {
  none,           // Aucun accès
  view,           // Lecture seule
  viewAndComment, // Lecture + commentaires
  edit,           // Modification
  fullControl,    // Contrôle total (CRUD + validation)
}

class AccessControlService {

  /// Vérifie l'accès à la Bibliothèque
  static AccessLevel getLibraryAccess(User user, String resourceType) {
    // Règle : La Communauté et les Membres peuvent voir Cantiques et Catéchisme
    if (resourceType == 'cantiques' || resourceType == 'catechisme' || resourceType == 'vision_eglise') {
      return AccessLevel.view;
    }

    // Règle : Pensée Directrice et Liturgie réservées aux Ministres et hiérarchie
    if (resourceType == 'pensee_directrice' || resourceType == 'liturgie') {
      if (user.role == UserRole.ministre || user.entityLevel == 'district' || user.entityLevel == 'champ' || user.entityLevel == 'territoriale' || user.entityLevel == 'internationale') {
        return AccessLevel.view;
      }
      return AccessLevel.none;
    }

    // Règle : Modification réservée à la hiérarchie (Champ et +)
    if (user.role == UserRole.apotreChamp || user.role == UserRole.presidentTerritoriale || user.role == UserRole.apotrePatriarche || user.role == UserRole.superAdmin) {
      return AccessLevel.fullControl;
    }

    return AccessLevel.view;
  }

  /// Vérifie si un ministre peut modifier directement
  /// RÈGLE : Les ministres ne peuvent PAS modifier directement s'ils ne sont pas responsables d'entité
  static bool canMinisterModifyDirectly(User user) {
    return user.role == UserRole.chefCommunaute || user.role == UserRole.apotreDistrict || user.role == UserRole.apotreChamp || user.role == UserRole.presidentTerritoriale;
  }
}
