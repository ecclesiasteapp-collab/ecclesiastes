import 'package:flutter/material.dart';
import 'package:ecclesiastes/models/hierarchy_models.dart';

/// Widget pour afficher les actions rapides adaptées au niveau d'entité
/// et au rôle (responsable vs suppléant)
class CommissionQuickActions extends StatelessWidget {
  final EntityLevel entityLevel;
  final bool isSuppleant;
  final VoidCallback? onNewReport;
  final VoidCallback? onCreateEvent;
  final VoidCallback? onManageMembers;
  final VoidCallback? onViewFinances;
  final VoidCallback? onAssignRoles;
  final VoidCallback? onExportData;

  const CommissionQuickActions({
    super.key,
    required this.entityLevel,
    this.isSuppleant = false,
    this.onNewReport,
    this.onCreateEvent,
    this.onManageMembers,
    this.onViewFinances,
    this.onAssignRoles,
    this.onExportData,
  });

  static const _colors = {
    'report': Colors.blue,
    'event': Colors.green,
    'members': Colors.orange,
    'finances': Colors.purple,
    'roles': Colors.red,
    'export': Colors.deepOrange,
  };

  /// Génère les actions disponibles selon le niveau et le rôle
  List<Map<String, dynamic>> _getAvailableActions() {
    final actions = <Map<String, dynamic>>[];

    // Actions disponibles pour tous les niveaux
    actions.addAll([
      {
        'label': 'Nouveau Rapport',
        'icon': Icons.description,
        'color': _colors['report'],
        'onTap': onNewReport,
        'visible': !isSuppleant,
      },
      {
        'label': 'Créer Événement',
        'icon': Icons.event,
        'color': _colors['event'],
        'onTap': onCreateEvent,
        'visible': !isSuppleant,
      },
    ]);

    // Actions selon le niveau d'entité
    switch (entityLevel) {
      case EntityLevel.internationale:
      case EntityLevel.territoriale:
      case EntityLevel.champ:
        actions.addAll([
          {
            'label': 'Gérer Membres',
            'icon': Icons.people,
            'color': _colors['members'],
            'onTap': onManageMembers,
            'visible': !isSuppleant,
          },
          {
            'label': 'Finances',
            'icon': Icons.attach_money,
            'color': _colors['finances'],
            'onTap': onViewFinances,
            'visible': true,
          },
          {
            'label': 'Assigner Rôles',
            'icon': Icons.assignment_ind,
            'color': _colors['roles'],
            'onTap': onAssignRoles,
            'visible': !isSuppleant,
          },
        ]);
        break;

      case EntityLevel.district:
        actions.addAll([
          {
            'label': 'Gérer Membres',
            'icon': Icons.people,
            'color': _colors['members'],
            'onTap': onManageMembers,
            'visible': !isSuppleant,
          },
          {
            'label': 'Finances',
            'icon': Icons.attach_money,
            'color': _colors['finances'],
            'onTap': onViewFinances,
            'visible': true,
          },
        ]);
        break;

      case EntityLevel.communaute:
        actions.addAll([
          {
            'label': 'Gérer Membres',
            'icon': Icons.people,
            'color': _colors['members'],
            'onTap': onManageMembers,
            'visible': !isSuppleant,
          },
        ]);
        break;
    }

    // Action export pour tous
    actions.add({
      'label': 'Exporter',
      'icon': Icons.download,
      'color': _colors['export'],
      'onTap': onExportData,
      'visible': !isSuppleant,
    });

    return actions.where((a) => a['visible'] as bool).toList();
  }

  @override
  Widget build(BuildContext context) {
    final actions = _getAvailableActions();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(16, 24, 16, 12),
          child: Text(
            'Actions Rapides',
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(
          height: 40,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: actions.length,
            itemBuilder: (context, index) {
              final action = actions[index];
              return GestureDetector(
                onTap: action['onTap'] as VoidCallback?,
                child: Container(
                  margin: const EdgeInsets.only(right: 8),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: (action['color'] as Color).withValues(alpha: 0.8),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        action['icon'] as IconData,
                        color: Colors.white,
                        size: 14,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        action['label'] as String,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

