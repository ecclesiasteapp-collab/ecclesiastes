import '../models/hierarchy_models.dart';

class Permission {
  static const String viewGlobalStats = 'view_global_stats';
  static const String manageTerritoriale = 'manage_territoriale';
  static const String approveChampLeader = 'approve_champ_leader';
  static const String approveDistrictLeader = 'approve_district_leader';
  static const String approveCommunityLeader = 'approve_community_leader';
  static const String manageCommissions = 'manage_commissions';
  static const String viewPastoralNotes = 'view_pastoral_notes';
  static const String submitReport = 'submit_report';
  static const String validateReport = 'validate_report';
  static const String exportAnalytics = 'export_analytics';
  static const String godMode = 'god_mode';
}

class RBACGuard {
  static bool can(UserRole role, String permission) {
    // Super Admin et Apôtre Patriarche ont tous les droits
    if (role == UserRole.apotrePatriarche || role == UserRole.superAdmin) return true;

    switch (role) {
      case UserRole.apotreDistrict:
        return [
          Permission.viewGlobalStats, Permission.manageTerritoriale, 
          Permission.approveChampLeader, Permission.exportAnalytics
        ].contains(permission);

      case UserRole.apotreResponsable:
      case UserRole.apotre:
        return [
          Permission.viewGlobalStats, Permission.approveDistrictLeader, 
          Permission.manageCommissions, Permission.validateReport
        ].contains(permission);

      case UserRole.eveque:
      case UserRole.ancien: // Responsable de District
        return [
          Permission.viewGlobalStats, Permission.approveCommunityLeader, 
          Permission.manageCommissions, Permission.validateReport, Permission.exportAnalytics
        ].contains(permission);

      case UserRole.lead:
      case UserRole.berger:
      case UserRole.evangeliste:
      case UserRole.pretre:
        return [
          Permission.submitReport, Permission.manageCommissions, Permission.viewPastoralNotes,
          Permission.validateReport
        ].contains(permission);

      case UserRole.diacre:
      case UserRole.sousDiacre:
      case UserRole.frereCharge:
      case UserRole.conductrice:
        return [Permission.viewPastoralNotes, Permission.submitReport].contains(permission);

      case UserRole.membre:
      default:
        return false;
    }
  }

  static List<UserRole> getValidationChain(UserRole initiator) {
    // Logique de cascade simplifiée selon la nouvelle hiérarchie
    if (initiator.index >= UserRole.pretre.index) {
      return [UserRole.ancien, UserRole.eveque, UserRole.apotre];
    }
    return [];
  }
}

