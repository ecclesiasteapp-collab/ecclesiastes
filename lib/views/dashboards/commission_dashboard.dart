import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../widgets/dashboard_modulaire.dart';
import '../../core/theme.dart';
import '../../services/auth_service.dart';
import '../../models/hierarchy_models.dart';
import '../../models/user.dart';

class CommissionDashboard extends StatelessWidget {
  final String commissionName;
  const CommissionDashboard({super.key, required this.commissionName});

  @override
  Widget build(BuildContext context) {
    final user = AuthService.currentUser;
    final String userName = user?.fullName ?? 'Utilisateur';
    final String userRole = user?.commissionType?.name ?? 'Commission';

    return DashboardModulaire(
      title: 'Resp. Commission $userRole',
      headerSubtitle: '${user?.entityLevel?.name ?? 'Entité'} • $userName',
      carouselItems: [
        _buildTaskCard(context, 'Rapport Mensuel', 'À soumettre sous 3 jours', Icons.pending_actions, '/reports/create'),
        _buildTaskCard(context, 'Prochain Programme', 'Formation moniteurs', Icons.school, '/programmes'),
      ],
      navigationTabs: [
        {'icon': Icons.description, 'label': 'Mes Rapports', 'route': '/reports'},
        {'icon': Icons.people, 'label': 'Membres', 'route': '/members'},
        {'icon': Icons.event_note, 'label': 'Programmes', 'route': '/programmes'},
        {'icon': Icons.auto_stories, 'label': 'Manuels', 'route': '/library'},
      ],
      bottomSection: [
        _buildSectionTitle('ÉTAT D\'AVANCEMENT DU MOIS', Icons.bar_chart),
        const SizedBox(height: 16),
        _buildProgressInfo(),
        const SizedBox(height: 20),
        _buildSectionTitle('ACTIONS RAPIDES', Icons.flash_on),
        const SizedBox(height: 16),
        _buildQuickActions(context, user),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildTaskCard(BuildContext context, String title, String status, IconData icon, String route) {
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
            Text(status, style: TextStyle(color: Colors.white.withValues(alpha: 0.7), fontSize: 11)),
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

  Widget _buildProgressInfo() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.05), borderRadius: BorderRadius.circular(15)),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Objectifs mensuels', style: TextStyle(color: Colors.white)),
              Text('75%', style: TextStyle(color: AppTheme.accent, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 12),
          LinearProgressIndicator(value: 0.75, backgroundColor: Colors.white10, valueColor: AlwaysStoppedAnimation(AppTheme.accent), minHeight: 4),
        ],
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context, User? user) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Wrap(
        spacing: 12,
        runSpacing: 12,
        children: [
          if (user?.commissionType == CommissionType.ecodim) 
            _buildQuickActionButton(context, 'Rapport Mensuel Ecodim', Icons.add_chart, '/reports/ecodim_mensuel')
          else
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

