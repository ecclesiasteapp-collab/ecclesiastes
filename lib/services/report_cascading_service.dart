import '../models/hierarchy_models.dart';

class ReportCascadingService {
  /// Détermine quel niveau doit valider le rapport
  static EntityLevel? getNextValidationLevel(EntityLevel? currentLevel) {
    if (currentLevel == null) return EntityLevel.communaute;
    switch (currentLevel) {
      case EntityLevel.communaute:
        return EntityLevel.district;
      case EntityLevel.district:
        return EntityLevel.champ;
      case EntityLevel.champ:
        return EntityLevel.territoriale;
      case EntityLevel.territoriale:
        return EntityLevel.internationale;
      case EntityLevel.internationale:
        return null; // Terminé
    }
  }

  static EntityLevel getNextValidatorLevel(EntityLevel currentLevel) =>
      getNextValidationLevel(currentLevel) ?? EntityLevel.internationale;

  static String getStatusLabel(EntityLevel? level) {
    if (level == null) return 'En attente de validation locale';
    switch (level) {
      case EntityLevel.communaute: return 'Validé par la Communauté';
      case EntityLevel.district: return 'Validé par le District';
      case EntityLevel.champ: return 'Validé par le Champ';
      case EntityLevel.territoriale: return 'Validé par la Territoriale';
      case EntityLevel.internationale: return 'Finalisé (International)';
    }
  }

  /// Détermine quel rôle ministériel est habilité à valider à ce niveau
  static List<UserRole> getRequiredRolesForLevel(EntityLevel level) {
    switch (level) {
      case EntityLevel.communaute:
        return [UserRole.pretre, UserRole.berger];
      case EntityLevel.district:
        return [UserRole.ancien, UserRole.lead];
      case EntityLevel.champ:
        return [UserRole.apotre, UserRole.eveque];
      case EntityLevel.territoriale:
        return [UserRole.apotreDistrict, UserRole.apotreResponsable];
      case EntityLevel.internationale:
        return [UserRole.apotrePatriarche];
    }
  }
}

