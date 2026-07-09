import '../models/hierarchy_models.dart';
import 'auth_service.dart';
import '../models/entity_space_mode.dart';

class EntityPrivilegeService {
  EntityPrivilegeService._();

  static UserRole? get _role => AuthService.currentUser?.role;

  static String normalizeEntityRole(String? role) {
    switch ((role ?? '').trim().toLowerCase()) {
      case 'responsable':
        return 'responsable';
      case 'suppleant':
      case 'suppléant':
      case 'adjoint':
        return 'suppleant';
      default:
        return '';
    }
  }

  static bool get isSuperAdmin => AuthService.isSuperAdmin();

  static bool get hasGodPrivilege => isSuperAdmin;

  static bool get isEntityResponsable =>
      normalizeEntityRole(AuthService.currentUser?.entityRole) == 'responsable';

  static bool get isEntitySuppleant =>
      normalizeEntityRole(AuthService.currentUser?.entityRole) == 'suppleant';

  static bool get isAdministrativeMinister {
    final role = _role;
    if (role == null) return false;
    return const {
      UserRole.apotrePatriarche,
      UserRole.apotreDistrict,
      UserRole.apotreResponsable,
      UserRole.apotre,
      UserRole.eveque,
      UserRole.ancien,
    }.contains(role);
  }

  static bool get canOpenEntitySpace =>
      hasGodPrivilege ||
      isAdministrativeMinister ||
      isEntityResponsable ||
      isEntitySuppleant;

  static bool get canOpenResponsableSpace =>
      hasGodPrivilege || isAdministrativeMinister || isEntityResponsable;

  static bool get canOpenSuppleantSpace =>
      hasGodPrivilege || isAdministrativeMinister || isEntitySuppleant;

  static bool get canOpenGodMode => hasGodPrivilege;

  static bool get isSuspended => AuthService.currentUser?.status == 'suspended';

  static bool get canAssignLeadership {
    if (isSuspended) return false;
    if (hasGodPrivilege) return true;
    
    final user = AuthService.currentUser;
    if (user == null) return false;

    // Vérification des délégations
    if (user.delegatedPermissions?.contains('nomination') ?? false) return true;

    // Règles hiérarchiques
    switch (user.entityLevel) {
      case EntityLevel.internationale:
        return true; 
      case EntityLevel.territoriale:
        return true; 
      case EntityLevel.regionApostolique:
        return true;
      case EntityLevel.champ:
        return true;
      default:
        return false;
    }
  }

  static EntitySpaceMode get defaultSpace {
    if (isSuspended) return EntitySpaceMode.standard;
    if (hasGodPrivilege) return EntitySpaceMode.god;
    if (isEntitySuppleant) return EntitySpaceMode.suppleant;
    if (isEntityResponsable || isAdministrativeMinister) {
      return EntitySpaceMode.responsable;
    }
    return EntitySpaceMode.standard;
  }

  static String get displayTitle {
    switch (defaultSpace) {
      case EntitySpaceMode.god:
        return 'Super Admin • God Mode';
      case EntitySpaceMode.suppleant:
        return 'Suppléant responsable';
      case EntitySpaceMode.responsable:
        return isAdministrativeMinister
            ? 'Administration d’entité'
            : 'Responsable d’entité';
      case EntitySpaceMode.auto:
      case EntitySpaceMode.standard:
        return 'Espace membre';
    }
  }

  static String get privilegeSummary {
    switch (defaultSpace) {
      case EntitySpaceMode.god:
        return 'Accès global, transversal et sans restriction sur toutes les entités.';
      case EntitySpaceMode.suppleant:
        return 'Accès délégué sur l’entité courante avec validation et suivi opérationnel.';
      case EntitySpaceMode.responsable:
        return 'Pilotage complet de l’entité courante, des validations et du suivi local.';
      case EntitySpaceMode.auto:
      case EntitySpaceMode.standard:
        return 'Accès standard limité à votre espace utilisateur.';
    }
  }

  static bool canAccessRoute(String route) {
    switch (route) {
      case '/admin/god-mode':
      case '/admin/super-admin':
      case '/admin/panel':
      case '/admin/users':
        return canOpenGodMode;
      case '/space/responsable':
        return canOpenResponsableSpace;
      case '/space/suppleant':
        return canOpenSuppleantSpace;
      default:
        return true;
    }
  }
}

