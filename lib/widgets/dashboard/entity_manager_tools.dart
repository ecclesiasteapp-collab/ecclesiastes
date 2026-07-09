import 'package:flutter/material.dart';
import 'package:ecclesiaste/utils/dashboard_theme.dart';

/// Widget pour afficher les outils du responsable d'entité
class EntityManagerToolsCard extends StatelessWidget {
  final VoidCallback? onSendDirective;
  final VoidCallback? onShareDocument;
  final VoidCallback? onViewStatistics;
  final VoidCallback? onManageMinistries;
  final int pendingDirectives;
  final int unreadMessages;

  const EntityManagerToolsCard({
    this.onSendDirective,
    this.onShareDocument,
    this.onViewStatistics,
    this.onManageMinistries,
    this.pendingDirectives = 0,
    this.unreadMessages = 0,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: DashboardTheme.cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // En-tête
          const Row(
            children: [
              Icon(
                Icons.admin_panel_settings,
                color: Color(0xFF1B6B9E),
                size: 24,
              ),
              SizedBox(width: 8),
              Text(
                "Outils de Gestion d'Entité",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1B6B9E),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Grille d'outils
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            children: [
              _ToolButton(
                icon: Icons.send,
                label: 'Envoyer Directive',
                description: 'Messages aux ministres',
                badge: pendingDirectives > 0 ? '$pendingDirectives' : null,
                onTap: onSendDirective,
                color: Colors.blue,
              ),
              _ToolButton(
                icon: Icons.folder_shared,
                label: 'Partager Document',
                description: 'Fichiers confidentiels',
                onTap: onShareDocument,
                color: Colors.orange,
              ),
              _ToolButton(
                icon: Icons.bar_chart,
                label: 'Statistiques',
                description: "Données de l'entité",
                onTap: onViewStatistics,
                color: Colors.green,
              ),
              _ToolButton(
                icon: Icons.people,
                label: 'Gérer Ministres',
                description: 'Assigner responsables',
                badge: unreadMessages > 0 ? '$unreadMessages' : null,
                onTap: onManageMinistries,
                color: Colors.purple,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Widget pour un bouton d'outil
class _ToolButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final String description;
  final String? badge;
  final VoidCallback? onTap;
  final Color color;

  const _ToolButton({
    required this.icon,
    required this.label,
    required this.description,
    required this.color,
    this.badge,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: color.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        child: Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  color: color,
                  size: 32,
                ),
                const SizedBox(height: 8),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.grey[600],
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            if (badge != null)
              Positioned(
                top: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    badge!,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/// Widget pour afficher les statistiques d'entité
class EntityStatisticsOverview extends StatelessWidget {
  final int totalMinisters;
  final int activeMinisters;
  final int pendingReports;
  final double budgetUtilization;
  final int newMembers;

  const EntityStatisticsOverview({
    required this.totalMinisters,
    required this.activeMinisters,
    required this.pendingReports,
    required this.budgetUtilization,
    required this.newMembers,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: DashboardTheme.cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(
                Icons.assessment,
                color: Color(0xFF1B6B9E),
                size: 24,
              ),
              SizedBox(width: 8),
              Text(
                "Vue d'ensemble de l'Entité",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1B6B9E),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _StatCard(
                  label: 'Ministres',
                  value: '$activeMinisters/$totalMinisters',
                  icon: Icons.people,
                  color: Colors.blue,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _StatCard(
                  label: 'Rapports',
                  value: '$pendingReports',
                  subtitle: 'en attente',
                  icon: Icons.description,
                  color: Colors.orange,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _StatCard(
                  label: 'Budget',
                  value: '${budgetUtilization.toStringAsFixed(1)}%',
                  icon: Icons.attach_money,
                  color: Colors.green,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _StatCard(
                  label: 'Croissance',
                  value: '+$newMembers',
                  subtitle: 'nouveaux',
                  icon: Icons.trending_up,
                  color: Colors.purple,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Widget pour une carte statistique
class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final String? subtitle;
  final IconData icon;
  final Color color;

  const _StatCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
              Icon(
                icon,
                color: color,
                size: 16,
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 4),
            Text(
              subtitle!,
              style: TextStyle(
                fontSize: 11,
                color: Colors.grey[500],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

