import 'package:ecclesiastes/services/auth_service.dart';
import 'package:ecclesiastes/utils/constants.dart';
import '../models/hierarchy_models.dart';

/// Profils d'accès déterminés au login (rôle + ministère).
class UserAccessProfile {
  UserAccessProfile._();

  static const superAdmin = 'SUPER_ADMIN';
  static const ministre = 'MINISTRE';
  static const responsableEntite = 'RESPONSABLE_ENTITE';
  static const responsableCommission = 'RESPONSABLE_COMMISSION';
  static const membre = 'MEMBRE';

  static String get current {
    final user = AuthService.currentUser;
    if (user == null) return membre;
    if (AuthService.isSuperAdmin()) return superAdmin;

    final role = user.role;
    if (user.commissionRole == CommissionRole.responsable ||
        user.commissionRole == CommissionRole.adjoint) {
      return responsableCommission;
    }

    if (user.entityRole == 'responsable' ||
        user.entityRole == 'suppleant' ||
        role == UserRole.apotrePatriarche ||
        role == UserRole.apotreDistrict ||
        role == UserRole.apotreResponsable ||
        role == UserRole.apotre ||
        role == UserRole.eveque ||
        role == UserRole.ancien) {
      return responsableEntite;
    }

    if (role != UserRole.membre) return ministre;

    return membre;
  }

  static String get displayTitle {
    final user = AuthService.currentUser;
    switch (current) {
      case superAdmin:
        return 'Super Administrateur';
      case ministre:
        return 'Apostolic Administrator';
      case responsableEntite:
        if (user?.entityRole == 'suppleant') {
          return 'Suppléant Responsable d\'entité';
        }
        return 'Responsable d\'entité';
      case responsableCommission:
        if (user?.commissionRole == CommissionRole.adjoint) {
          return 'Suppléant Responsable de commission';
        }
        return 'Responsable de commission';
      default:
        return 'Membre';
    }
  }

  static bool get canManageEntites => current == superAdmin;
  static bool get canManageCommissions => current == superAdmin;
  static bool get canSeeFinances => current == superAdmin || current == ministre || current == responsableEntite;
  static bool get canSeeCommissionsGrid => current == superAdmin || current == ministre || current == responsableEntite || current == responsableCommission;
  static bool get canSeeEntityFilters => current == superAdmin || current == ministre || current == responsableEntite;
  static bool get canSeeDailyReport => current == superAdmin || current == ministre || current == responsableEntite;
  static bool get canManageMembers => current != membre;
  static bool get canValidateInscriptions => current == superAdmin || current == ministre || current == responsableEntite;
  static bool get canConsolidateReports => current == superAdmin || current == ministre || current == responsableEntite;
  static bool get canAccessBibliotheque => true;
  static bool get canAddDocument => current == superAdmin || current == ministre || current == responsableEntite || current == responsableCommission;
  static bool get canDeleteDocument => current == superAdmin || current == ministre || current == responsableEntite;

  static String get bibliothequeNiveau {
    switch (current) {
      case superAdmin:
        return 'eglise_territoriale';
      case ministre:
        return 'champ';
      case responsableEntite:
        return 'district';
      default:
        return 'communaute';
    }
  }

  static bool get showOnlyOwnCommission => current == responsableCommission;

  static String? get commissionFilter {
    if (!showOnlyOwnCommission) return null;
    return AuthService.currentUser?.commissionType?.name;
  }

  static bool isProcheRetraite(String? dateNaissance) {
    if (dateNaissance == null || dateNaissance.isEmpty) return false;
    final naissance = DateTime.tryParse(dateNaissance);
    if (naissance == null) return false;
    final age = DateTime.now().difference(naissance).inDays ~/ 365;
    return age >= AppConstants.ageRetraite - 2;
  }

  static int? ageActuel(String? dateNaissance) {
    if (dateNaissance == null || dateNaissance.isEmpty) return null;
    final naissance = DateTime.tryParse(dateNaissance);
    if (naissance == null) return null;
    return DateTime.now().difference(naissance).inDays ~/ 365;
  }
}

