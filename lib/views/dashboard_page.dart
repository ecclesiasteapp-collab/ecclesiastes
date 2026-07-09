import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ecclesiaste/services/auth_service.dart';
import 'package:ecclesiaste/models/hierarchy_models.dart';
// L'énumération EntityResponsibleRole est maintenant définie dans hierarchy_models.dart
// import 'package:ecclesiaste/models/entity_responsible_role.dart'; // Supprimé car redondant

import 'dashboards/member_dashboard.dart';
import 'dashboards/minister_dashboard.dart';
import 'dashboards/commission_dashboard.dart';
import 'dashboards/main_dashboard.dart';
import 'dashboards/dashboard_responsable_entite_page.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = AuthService.currentUser;

    if (user == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (context.mounted) {
          context.go('/login');
        }
      });
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    // Détermination du Dashboard selon la hiérarchie officielle
    if (user.role == UserRole.superAdmin || _isAdministrativeRole(user.role)) {
      return const MainDashboard();
    }

    if (user.entityRole == EntityResponsibleRole.responsable.name || user.entityRole == EntityResponsibleRole.suppleant.name) {
      return const DashboardResponsableEntitePage();
    }

    if (user.commissionRole == CommissionRole.responsable ||
        user.commissionRole == CommissionRole.adjoint) {
      return CommissionDashboard(commissionName: user.commissionType?.name ?? 'Commission');
    }

    if (user.role == UserRole.membre) {
      return const MemberDashboard();
    }

    // Par défaut pour les ministres de culte sans charge administrative globale
    return const MinisterDashboard();
  }

  /// Les rôles ayant accès au Dashboard de gestion globale (Synoptique)
  bool _isAdministrativeRole(UserRole role) {
    // Définir une énumération pour les rôles d'entité si elle n'existe pas déjà
    // et l'utiliser ici pour éviter les chaînes de caractères en dur.
    // Pour l'instant, nous utilisons des constantes.
    // const String responsable = 'responsable';
    // const String suppleant = 'suppleant';

    return role == UserRole.superAdmin ||
           role == UserRole.apotrePatriarche ||
           role == UserRole.apotreDistrict ||
           role == UserRole.apotreResponsable ||
           role == UserRole.apotre ||
           role == UserRole.eveque ||
           role == UserRole.ancien; // Ancien = Responsable de District
  }
}

