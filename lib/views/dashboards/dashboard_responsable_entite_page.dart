import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ecclesiastes/services/auth_service.dart';
import 'package:ecclesiastes/models/hierarchy_models.dart';
import 'package:ecclesiastes/widgets/dashboard_modulaire.dart';
import 'package:ecclesiastes/widgets/dashboard/entite_hierarchy_pills.dart';
import 'package:ecclesiastes/core/theme.dart';
import 'package:ecclesiastes/config/organization_config.dart';

class DashboardResponsableEntitePage extends StatelessWidget {
  const DashboardResponsableEntitePage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = AuthService.currentUser;
    final String userName = user?.fullName ?? 'Responsable';
    final String entityName = user?.entityLevel?.name ?? 'Entité';

    return DashboardModulaire(
      title: 'Dashboard Responsable',
      headerSubtitle: '$entityName • $userName',
      topSection: const EntiteHierarchyPills(),
      carouselItems: [
        _buildInfoCard(context, 'Rapports à valider', '2 rapports en attente', Icons.assignment_turned_in, '/reports'),
        _buildInfoCard(context, 'Membres à suivre', '3 nouveaux membres', Icons.person_add, '/members'),
        _buildInfoCard(context, 'Événements à venir', 'Prochaine réunion le 30/06', Icons.event, '/calendar'),
      ],
      navigationTabs: [
        {'icon': Icons.description, 'label': 'Rapports', 'route': '/reports'},
        {'icon': Icons.people, 'label': 'Membres', 'route': '/members'},
        {'icon': Icons.event_note, 'label': 'Programmes', 'route': '/programmes'},
        {'icon': Icons.auto_stories, 'label': 'Manuels', 'route': '/library'},
      ],
      bottomSection: [
        _buildSectionTitle("COMMISSIONS DE L'ENTITÉ", Icons.groups),
        const SizedBox(height: 16),
        _buildCommissionsGrid(context),
        const SizedBox(height: 20),
        _buildSectionTitle('ACTIONS RAPIDES', Icons.flash_on),
        const SizedBox(height: 16),
        _buildQuickActions(context),
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

  Widget _buildCommissionsGrid(BuildContext context) {
    final user = AuthService.currentUser;
    final EntityLevel level = user?.entityLevel ?? EntityLevel.communaute;
    final List<CommissionDefinition> commissions = OrganizationConfig.commissions;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 0.85,
        ),
        itemCount: commissions.length,
        itemBuilder: (context, index) {
          final CommissionDefinition commission = commissions[index];
          final String responsible = level == EntityLevel.communaute ? 'Responsable local' : 'Responsable désigné';
          return _buildMiniCommissionCard(
            context,
            commission.name,
            responsible,
            75,
            AppTheme.accent,
          );
        },
      ),
    );
  }

  Widget _buildMiniCommissionCard(
    BuildContext context,
    String name,
    String responsible,
    int progress,
    Color color,
  ) {
    return GestureDetector(
      onTap: () => context.go(
        '/commissions/detail/${name.toLowerCase()}',
        extra: {
          'commissionName': name,
          'leaderName': responsible,
          'progress': progress.toDouble(),
          'entityId': AuthService.currentUser?.entityId ?? 'unknown',
        },
      ),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Icon(Icons.group, color: Colors.white54, size: 14),
                Icon(Icons.bookmark, color: color, size: 14),
              ],
            ),
            const Spacer(),
            Text(
              name,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 11,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              responsible,
              style: const TextStyle(color: Colors.white54, fontSize: 9),
            ),
            const SizedBox(height: 6),
            LinearProgressIndicator(
              value: progress / 100,
              backgroundColor: Colors.white10,
              valueColor: AlwaysStoppedAnimation<Color>(color),
              minHeight: 2,
            ),
          ],
        ),
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
          _buildQuickActionButton(context, 'Gérer Membres', Icons.group_add, '/members'),
          _buildQuickActionButton(context, 'Créer Annonce', Icons.campaign, '/announcements/create'),
          _buildQuickActionButton(context, 'Saisir Finance', Icons.account_balance_wallet, '/finances/saisie'),
          _buildQuickActionButton(context, 'Planifier SD', Icons.event_note, '/planning/sd'),
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

