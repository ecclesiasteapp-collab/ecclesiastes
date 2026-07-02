import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../widgets/dashboard_modulaire.dart';
import '../../services/auth_service.dart';
import '../../widgets/dashboard/entite_hierarchy_pills.dart';
import '../../core/theme.dart';

class MainDashboard extends StatelessWidget {
  const MainDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final user = AuthService.currentUser;
    final String userName = user?.fullName ?? 'Administrateur';

    return DashboardModulaire(
      title: 'Dashboard Global',
      headerSubtitle: 'Bienvenue, $userName',
      topSection: const EntiteHierarchyPills(),
      carouselItems: [
        _buildInfoCard(
          context,
          'Rapports en attente',
          '5 rapports à valider',
          Icons.pending_actions,
          '/reports',
        ),
        _buildInfoCard(
          context,
          'Nouvelles annonces',
          '3 nouvelles publications',
          Icons.campaign,
          '/announcements',
        ),
        _buildInfoCard(
          context,
          'Membres inscrits',
          '12 nouveaux membres ce mois-ci',
          Icons.person_add,
          '/members',
        ),
      ],
      navigationTabs: [
        {'icon': Icons.description, 'label': 'Rapports', 'route': '/reports'},
        {'icon': Icons.people, 'label': 'Membres', 'route': '/members'},
        {'icon': Icons.event_note, 'label': 'Calendrier', 'route': '/calendar'},
        {'icon': Icons.account_balance, 'label': 'Finances', 'route': '/finances/journal'},
      ],
      bottomSection: [
        _buildSectionTitle('STATISTIQUES CLÉS', Icons.analytics),
        const SizedBox(height: 16),
        _buildStatsGrid(),
        const SizedBox(height: 20),
        _buildSectionTitle('GESTION RAPIDE', Icons.settings_applications),
        const SizedBox(height: 16),
        _buildManagementActions(context),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildInfoCard(
    BuildContext context,
    String title,
    String subtitle,
    IconData icon,
    String route,
  ) {
    return GestureDetector(
      onTap: () => context.go(route),
      child: Container(
        width: 180,
        margin: const EdgeInsets.only(right: 12),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: AppTheme.accent, size: 28),
            const Spacer(),
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
            Text(
              subtitle,
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.7),
                fontSize: 11,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.white, size: 20),
          const SizedBox(width: 8),
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsGrid() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: GridView.count(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.8,
        children: [
          _buildStatItem('Total Membres', '12,345', Icons.group, Colors.blueAccent),
          _buildStatItem('Total Entités', '120', Icons.location_city, Colors.greenAccent),
          _buildStatItem('Rapports Validés', '98%', Icons.check_circle, Colors.orangeAccent),
          _buildStatItem('Actifs en ligne', '2,100', Icons.wifi, Colors.purpleAccent),
        ],
      ),
    );
  }

  Widget _buildStatItem(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(icon, color: color, size: 28),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.7),
                  fontSize: 12,
                ),
              ),
              Text(
                value,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildManagementActions(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Wrap(
        spacing: 12,
        runSpacing: 12,
        children: [
          _buildQuickActionButton(context, 'Gérer Entités', Icons.corporate_fare, '/admin/panel'),
          _buildQuickActionButton(context, 'Gérer Utilisateurs', Icons.manage_accounts, '/admin/users'),
          _buildQuickActionButton(context, 'Paramètres App', Icons.settings, '/settings'),
          _buildQuickActionButton(context, "Journal d'Audit", Icons.receipt_long, '/audit_log'),
        ],
      ),
    );
  }

  Widget _buildQuickActionButton(
    BuildContext context,
    String label,
    IconData icon,
    String route,
  ) {
    return ElevatedButton.icon(
      onPressed: () => context.go(route),
      icon: Icon(icon, color: Colors.white),
      label: Text(label, style: const TextStyle(color: Colors.white)),
      style: ElevatedButton.styleFrom(
        backgroundColor: AppTheme.primary.withValues(alpha: 0.8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      ),
    );
  }
}

