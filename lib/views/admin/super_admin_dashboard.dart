import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../widgets/dashboard_modulaire.dart';
import '../../models/user.dart';
import '../../core/theme.dart';

class SuperAdminDashboard extends StatelessWidget {
  final User admin;
  const SuperAdminDashboard({super.key, required this.admin});

  @override
  Widget build(BuildContext context) {
    final String userName = admin.fullName;

    return DashboardModulaire(
      title: 'Console Direction Mondiale',
      headerSubtitle: 'Bienvenue, $userName',
      carouselItems: [
        _buildInfoCard(context, 'Directives Pastorales', 'Nouvelles circulaires 2026', Icons.gavel, '/library'),
        _buildInfoCard(context, 'Visites Apostoliques', 'Planification des tournées', Icons.church, '/calendar'),
        _buildInfoCard(context, 'Bilan des Commissions', 'Rapports annuels disponibles', Icons.analytics, '/reports'),
      ],
      navigationTabs: [
        {'icon': Icons.account_tree, 'label': 'Entités', 'route': '/hierarchie'},
        {'icon': Icons.groups, 'label': 'Commissions', 'route': '/commissions'},
        {'icon': Icons.person, 'label': 'Utilisateurs', 'route': '/admin/users'},
        {'icon': Icons.description, 'label': 'Rapports', 'route': '/reports'},
      ],
      bottomSection: [
        _buildSectionTitle('STATISTIQUES GLOBALES', Icons.public),
        const SizedBox(height: 16),
        _buildGlobalStatsGrid(),
        const SizedBox(height: 20),
        _buildSectionTitle('ACTIONS ADMINISTRATIVES', Icons.admin_panel_settings),
        const SizedBox(height: 16),
        _buildAdminActions(context),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildInfoCard(BuildContext context, String title, String subtitle, IconData icon, String route) {
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
            Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
            Text(subtitle, style: TextStyle(color: Colors.white.withValues(alpha: 0.7), fontSize: 11)),
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
            )
          )
        ],
      ),
    );
  }

  Widget _buildGlobalStatsGrid() {
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
          _buildStatItem('Total Membres', '1.2M', Icons.group, Colors.blueAccent),
          _buildStatItem('Total Entités', '5,000', Icons.location_city, Colors.greenAccent),
          _buildStatItem('Rapports Validés', '99%', Icons.check_circle, Colors.orangeAccent),
          _buildStatItem('Utilisateurs Actifs', '500K', Icons.person_pin, Colors.purpleAccent),
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
              Text(title, style: TextStyle(color: Colors.white.withValues(alpha: 0.7), fontSize: 12)),
              Text(value, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAdminActions(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Wrap(
        spacing: 12,
        runSpacing: 12,
        children: [
          _buildQuickActionButton(context, 'Gérer Entités', Icons.corporate_fare, '/admin/panel'),
          _buildQuickActionButton(context, 'Gouvernance', Icons.account_balance, '/admin/governance'),
          _buildQuickActionButton(context, 'Gérer Utilisateurs', Icons.manage_accounts, '/admin/users'),
          _buildQuickActionButton(context, 'Paramètres App', Icons.settings, '/settings'),
        ],
      ),
    );
  }

  Widget _buildQuickActionButton(BuildContext context, String label, IconData icon, String route) {
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

