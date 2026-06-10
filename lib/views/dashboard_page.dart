import 'package:flutter/material.dart';
import 'package:ecclesiastes/services/auth_service.dart';
import 'package:ecclesiastes/models/hierarchy_models.dart';
import 'dashboards/member_dashboard.dart';
import 'dashboards/minister_dashboard.dart';
import 'dashboards/commission_dashboard.dart';
import 'dashboards/main_dashboard.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final roleStr = AuthService.currentUser?['role'] ?? 'MEMBRE';
    final roleLabel = AuthService.currentUser?['role_label'] ?? '';
    
    UserRole userRole;
    if (roleStr == 'SUPER_ADMIN' || roleStr == 'RESPONSABLE') {
      userRole = UserRole.chefCommunaute;
    } else if (roleStr == 'MINISTRE') {
      userRole = UserRole.ministre;
    } else if (roleLabel.contains('Commission')) {
      userRole = UserRole.respCommission;
    } else {
      userRole = UserRole.membre;
    }

    // Si c'est un rôle administratif, on utilise le nouveau MainDashboard qui gère son propre layout
    if (userRole == UserRole.chefCommunaute || userRole == UserRole.apotrePatriarche || userRole == UserRole.apotreDistrict || userRole == UserRole.apotreChamp || userRole == UserRole.presidentTerritoriale) {
      return const MainDashboard();
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ecclesiastes'),
        actions: [
          IconButton(icon: const Icon(Icons.logout), onPressed: () {
            AuthService.logout();
            Navigator.pushReplacementNamed(context, '/login');
          })
        ],
      ),
      body: _buildDashboard(userRole, roleLabel),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: const Color(0xFF003366),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: 'Tableau'),
          BottomNavigationBarItem(icon: Icon(Icons.library_books), label: 'Directives'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
        ],
      ),
    );
  }

  Widget _buildDashboard(UserRole role, String commissionName) {
    switch (role) {
      case UserRole.ministre:
        return const MinisterDashboard();
      case UserRole.respCommission:
        return CommissionDashboard(commissionName: commissionName);
      case UserRole.membre:
      default:
        return const MemberDashboard();
    }
  }
}
