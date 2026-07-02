import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../widgets/dashboard_modulaire.dart';
import '../../services/auth_service.dart';
import '../../core/theme.dart';

class MinisterDashboard extends StatelessWidget {
  const MinisterDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final user = AuthService.currentUser;
    final String userName = user?.fullName ?? 'Ministre';

    return DashboardModulaire(
      title: 'Dashboard Ministre',
      headerSubtitle: 'Bienvenue, $userName',
      carouselItems: [
        _buildInfoCard(context, 'Prochain Culte', 'Dimanche 09:00', Icons.church, '/calendar'),
        _buildInfoCard(context, 'Visites Pastorales', '3 visites à planifier', Icons.home, '/members'),
        _buildInfoCard(context, 'Rapports en attente', '1 rapport à soumettre', Icons.assignment_turned_in, '/reports/create'),
      ],
      navigationTabs: [
        {'icon': Icons.description, 'label': 'Rapports', 'route': '/reports'},
        {'icon': Icons.people, 'label': 'Membres', 'route': '/members'},
        {'icon': Icons.event_note, 'label': 'Programmes', 'route': '/programmes'},
        {'icon': Icons.auto_stories, 'label': 'Manuels', 'route': '/library'},
      ],
      bottomSection: [
        _buildSectionTitle('RAPPORTS RÉCENTS', Icons.history),
        const SizedBox(height: 16),
        _buildRecentReports(),
        const SizedBox(height: 20),
        _buildSectionTitle('ACTIONS RAPIDES', Icons.flash_on),
        const SizedBox(height: 16),
        _buildQuickActions(context),
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

  Widget _buildRecentReports() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildReportItem('Rapport Service Divin', 'Validé', Colors.green),
          const Divider(color: Colors.white10),
          _buildReportItem('Rapport Visite Pastorale', 'En attente', Colors.orange),
          const Divider(color: Colors.white10),
          _buildReportItem('Rapport Réunion de Frères', 'Validé', Colors.green),
        ],
      ),
    );
  }

  Widget _buildReportItem(String title, String status, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(color: Colors.white, fontSize: 14)),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(color: color.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(5)),
            child: Text(status, style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Wrap(
        spacing: 12,
        runSpacing: 12,
        children: [
          _buildQuickActionButton(context, 'Nouveau Rapport', Icons.add_chart, '/reports/create'),
          _buildQuickActionButton(context, 'Gérer Membres', Icons.group_add, '/members'),
          _buildQuickActionButton(context, 'Voir Calendrier', Icons.calendar_today, '/calendar'),
          _buildQuickActionButton(context, 'Ma Bibliothèque', Icons.menu_book, '/library'),
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

