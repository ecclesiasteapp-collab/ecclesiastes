enum Permission {
  viewAll,
  viewDistrict,
  viewCommunity,
  viewReadOnly,
  editReports,
  validateCommunity,
  validateHierarchical,
  manageUsers,
  manageLibrary,
  accessConfidentialPastoral,
}

class RBAC {
  static bool hasPermission(String roleLabel, Permission perm) {
    // Logique basée sur les rôles officiels de l'ENA
    switch (roleLabel) {
      case 'Super Administrateur':
      case 'Apôtre de district':
        return true; // Accès total
      case 'Responsable de district (ministère sacerdotal)':
        return [Permission.viewDistrict, Permission.viewCommunity, Permission.editReports, Permission.validateCommunity].contains(perm);
      case 'Responsable de communauté (ministère sacerdotal)':
        return [Permission.viewCommunity, Permission.editReports, Permission.validateCommunity].contains(perm);
      default:
        // Pour les ministres sans mandat ou membres
        return perm == Permission.viewReadOnly;
    }
  }
}
