enum AdminLevel {
  community,    // Responsable communauté
  district,     // Responsable district + accès communautés
  champ,        // Responsable champ + accès districts
  apostolicRegion, // Responsable région apostolique + accès champs
  territorial,  // Responsable territorial + accès champs
  superAdmin    // Accès total + gestion utilisateurs
}

class AdminPermissions {
  static const Map<AdminLevel, Set<String>> permissions = {
    AdminLevel.community: {'view:community', 'edit:community', 'submit:reports'},
    AdminLevel.district: {'view:community', 'view:district', 'validate:community', 'view:reports'},
    AdminLevel.champ: {'view:community', 'view:district', 'view:champ', 'validate:district', 'export:reports'},
    AdminLevel.apostolicRegion: {'view:community', 'view:district', 'view:champ', 'view:apostolicRegion', 'validate:champ', 'export:reports'},
    AdminLevel.territorial: {'view:all', 'validate:champ', 'manage:users', 'analytics:global'},
    AdminLevel.superAdmin: {'view:all', 'edit:all', 'delete:all', 'manage:system', 'audit:logs', 'edit:international_church'},
  };
  
  static bool can(AdminLevel level, String permission) => 
      permissions[level]?.contains(permission) ?? false;
}

