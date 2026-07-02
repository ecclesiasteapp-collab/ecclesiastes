import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../widgets/dashboard_modulaire.dart';
import '../../services/auth_service.dart';
import '../../core/theme.dart';

class MemberDashboard extends StatelessWidget {
  const MemberDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final user = AuthService.currentUser;
    final String userName = user?.fullName ?? 'Membre';

    return DashboardModulaire(
      title: 'Dashboard Membre',
      headerSubtitle: 'Bienvenue, $userName',
      carouselItems: [
        _buildInfoCard(context, 'Mon Profil', 'Mettre à jour mes informations', Icons.person, '/profile'),
        _buildInfoCard(context, 'Ma Bibliothèque', 'Accéder aux ressources', Icons.menu_book, '/library'),
        _buildInfoCard(context, 'Mon Calendrier', 'Voir les événements', Icons.calendar_today, '/calendar'),
      ],
      navigationTabs: [
        {'icon': Icons.book, 'label': 'Bible', 'route': '/bible'},
        {'icon': Icons.menu_book, 'label': 'Bibliothèque', 'route': '/library'},
        {'icon': Icons.calendar_today, 'label': 'Calendrier', 'route': '/calendar'},
        {'icon': Icons.share, 'label': 'Social Hub', 'route': '/social-hub'},
      ],
      bottomSection: [
        _buildSectionTitle('MES ACTIVITÉS RÉCENTES', Icons.history),
        const SizedBox(height: 16),
        _buildRecentActivities(),
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

  Widget _buildRecentActivities() {
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
          _buildActivityItem('Participation au culte', 'Dimanche 23 Juin', Icons.church),
          const Divider(color: Colors.white10),
          _buildActivityItem('Lecture biblique', 'Genèse 1-3', Icons.book_outlined),
          const Divider(color: Colors.white10),
          _buildActivityItem('Visite pastorale', '15 Juin', Icons.home_work),
        ],
      ),
    );
  }

  Widget _buildActivityItem(String title, String subtitle, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: AppTheme.accent, size: 20),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(color: Colors.white, fontSize: 14)),
              Text(subtitle, style: TextStyle(color: Colors.white.withValues(alpha: 0.7), fontSize: 12)),
            ],
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
          _buildQuickActionButton(context, 'Ma Bible', Icons.menu_book, '/bible'),
          _buildQuickActionButton(context, 'Mes Annonces', Icons.campaign, '/announcements'),
          _buildQuickActionButton(context, 'Mon Profil', Icons.person, '/profile'),
          _buildQuickActionButton(context, 'Aide', Icons.help_outline, '/help'),
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

