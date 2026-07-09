import 'package:flutter/material.dart';
import 'package:ecclesiaste/utils/dashboard_theme.dart';

/// Widget pour afficher une statistique clé avec indicateur visuel
class StatisticTile extends StatelessWidget {
  final String label;
  final String value;
  final String? unit;
  final IconData icon;
  final Color color;
  final double? percentage;
  final bool isLoading;

  const StatisticTile({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
    this.unit,
    this.percentage,
    this.isLoading = false,
    super.key,
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
            children: [
              Icon(icon, color: color, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  label,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          if (isLoading)
            const SizedBox(
              height: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          else
            Row(
              children: [
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
                if (unit != null) ...[
                  const SizedBox(width: 4),
                  Text(
                    unit!,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ],
            ),
          if (percentage != null) ...[
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: percentage! / 100,
                minHeight: 4,
                backgroundColor: color.withValues(alpha: 0.2),
                valueColor: AlwaysStoppedAnimation<Color>(color),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '${percentage!.toStringAsFixed(1)}%',
              style: TextStyle(
                fontSize: 11,
                color: Colors.grey,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// Widget pour afficher les statistiques ministérielles
class MinistryStatisticsCard extends StatelessWidget {
  final Map<String, dynamic>? statistics;
  final bool isLoading;
  final VoidCallback? onRefresh;

  const MinistryStatisticsCard({
    required this.statistics,
    required this.isLoading,
    this.onRefresh,
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
          Row(
            children: [
              const Icon(
                Icons.bar_chart,
                color: Color(0xFF1B6B9E),
                size: 24,
              ),
              const SizedBox(width: 8),
              const Text(
                'Statistiques de mon Entité',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1B6B9E),
                ),
              ),
              const Spacer(),
              if (onRefresh != null)
                IconButton(
                  icon: const Icon(Icons.refresh, size: 20),
                  onPressed: onRefresh,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
            ],
          ),
          const SizedBox(height: 16),

          // Contenu
          if (isLoading)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: CircularProgressIndicator(),
              ),
            )
          else if (statistics == null)
            Container(
              padding: const EdgeInsets.all(24),
              child: Center(
                child: Column(
                  children: [
                    Icon(
                      Icons.analytics_outlined,
                      size: 48,
                      color: Colors.grey[300],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Aucune donnée disponible',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            )
          else
            Column(
              children: [
                // Présence et participation
                Row(
                  children: [
                    Expanded(
                      child: StatisticTile(
                        label: 'Taux de Présence',
                        value: (statistics!['taux_presence'] as num?)?.toStringAsFixed(1) ?? '0',
                        unit: '%',
                        icon: Icons.people,
                        color: Colors.blue,
                        percentage: (statistics!['taux_presence'] as num?)?.toDouble() ?? 0,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: StatisticTile(
                        label: 'Participation',
                        value: (statistics!['participants_actifs'] as num?)?.toInt().toString() ?? '0',
                        unit: 'actifs',
                        icon: Icons.group,
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Rapports et activités
                Row(
                  children: [
                    Expanded(
                      child: StatisticTile(
                        label: 'Rapports Remis',
                        value: (statistics!['rapports_remis'] as num?)?.toInt().toString() ?? '0',
                        icon: Icons.description,
                        color: Colors.orange,
                        percentage: (statistics!['taux_completion_rapports'] as num?)?.toDouble() ?? 0,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: StatisticTile(
                        label: 'Activités Réalisées',
                        value: (statistics!['activites_realisees'] as num?)?.toInt().toString() ?? '0',
                        icon: Icons.event,
                        color: Colors.purple,
                        percentage: (statistics!['taux_realisation_activites'] as num?)?.toDouble() ?? 0,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Finances
                Row(
                  children: [
                    Expanded(
                      child: StatisticTile(
                        label: 'Offrandes (FC)',
                        value: (statistics!['offrandes_fc'] as num?)?.toStringAsFixed(0) ?? '0',
                        icon: Icons.attach_money,
                        color: Colors.teal,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: StatisticTile(
                        label: 'Offrandes (USD)',
                        value: (statistics!['offrandes_usd'] as num?)?.toStringAsFixed(2) ?? '0',
                        unit: '\$',
                        icon: Icons.currency_exchange,
                        color: Colors.indigo,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Croissance
                Row(
                  children: [
                    Expanded(
                      child: StatisticTile(
                        label: 'Nouveaux Membres',
                        value: (statistics!['nouveaux_membres'] as num?)?.toInt().toString() ?? '0',
                        icon: Icons.person_add,
                        color: Colors.cyan,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: StatisticTile(
                        label: 'Saint Scellés',
                        value: (statistics!['saint_scelles'] as num?)?.toInt().toString() ?? '0',
                        icon: Icons.favorite,
                        color: Colors.red,
                      ),
                    ),
                  ],
                ),
              ],
            ),
        ],
      ),
    );
  }
}

