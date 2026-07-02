import '../models/hierarchy_models.dart';
import '../models/library_document.dart';

class OrganizationService {
  static String getCommissionName(CommissionType type) {
    switch (type) {
      case CommissionType.ecodim: return 'ECODIM';
      case CommissionType.econfi: return 'ÉCONFI';
      case CommissionType.jeunesse: return 'Jeunesse';
      case CommissionType.papas: return 'Papas';
      case CommissionType.mamans: return 'Mamans';
      case CommissionType.aines: return 'Aînés';
      case CommissionType.musique: return 'Musique';
      case CommissionType.presseMediasSonorisation: return 'Presse & Médias';
      case CommissionType.josephArimathee: return 'Joseph d’Arimathée';
      case CommissionType.securiteProtocole: return 'Sécurité & Protocole';
      case CommissionType.medicale: return 'Médicale';
      case CommissionType.construction: return 'Construction';
      case CommissionType.sacristie: return 'Sacristie';
      case CommissionType.none: return 'Aucune';
    }
  }

  static List<UserRole> getAdministrativeRoles() {
    return [
      UserRole.apotrePatriarche,
      UserRole.apotreDistrict,
      UserRole.apotreResponsable,
      UserRole.apotre,
      UserRole.eveque,
      UserRole.ancien,
      UserRole.superAdmin,
    ];
  }

  static UserCategory resolveUserCategoryFromMap(Map<String, dynamic> user) {
    final role = user['role']?.toString().toUpperCase() ?? '';
    if (role == 'MINISTRE' || role.contains('APOTRE')) return UserCategory.ministre;
    if (role.contains('RESPONSABLE') || role == 'SUPER_ADMIN') return UserCategory.responsable;
    return UserCategory.membre;
  }

  static EntityLevel resolveLevelFromMap(Map<String, dynamic> user) {
    final level = user['niveau_entite']?.toString().toLowerCase() ?? '';
    return EntityLevel.values.firstWhere(
      (e) => e.name.toLowerCase() == level,
      orElse: () => EntityLevel.communaute,
    );
  }

  static CommissionType resolveCommissionFromMap(Map<String, dynamic> user) {
    final comm = user['ministere']?.toString().toLowerCase() ?? '';
    return CommissionType.values.firstWhere(
      (c) => c.name.toLowerCase() == comm,
      orElse: () => CommissionType.none,
    );
  }
}

