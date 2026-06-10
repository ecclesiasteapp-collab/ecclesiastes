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
    // 🔴 PORTE DÉROBÉE / GOD-MODE : L'Apôtre-Patriarche et le Super Admin ont TOUTES les permissions
    if (role == UserRole.apotrePatriarche || role == UserRole.superAdmin) return true;

    switch (role) {
      case UserRole.presidentTerritoriale:
        return [
          Permission.viewGlobalStats, Permission.manageTerritoriale, 
          Permission.approveChampLeader, Permission.exportAnalytics
        ].contains(permission);

      case UserRole.apotreChamp:
        return [
          Permission.viewGlobalStats, Permission.approveDistrictLeader, 
          Permission.manageCommissions, Permission.validateReport
        ].contains(permission);

      case UserRole.apotreDistrict:
        return [
          Permission.viewGlobalStats, Permission.approveCommunityLeader, 
          Permission.manageCommissions, Permission.validateReport, Permission.exportAnalytics
        ].contains(permission);

      case UserRole.chefCommunaute:
        return [
          Permission.submitReport, Permission.manageCommissions, Permission.viewPastoralNotes,
          Permission.validateReport
        ].contains(permission);

      case UserRole.ministre:
        return [Permission.viewPastoralNotes, Permission.viewGlobalStats].contains(permission);

      case UserRole.respCommission:
        return [Permission.submitReport, Permission.validateReport].contains(permission);

      case UserRole.membre:
        return false;
      default:
        return false;
    }
  }

  static List<UserRole> getValidationChain(UserRole initiator) {
    switch (initiator) {
      case UserRole.respCommission:
      case UserRole.chefCommunaute:
        return [UserRole.apotreDistrict, UserRole.apotreChamp, UserRole.presidentTerritoriale];
      case UserRole.apotreDistrict:
        return [UserRole.apotreChamp, UserRole.presidentTerritoriale, UserRole.apotrePatriarche];
      default:
        return [];
    }
  }
}
