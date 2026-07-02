import 'package:flutter/material.dart';
import 'package:ecclesiastes/models/hierarchy_models.dart';

/// Widget réutilisable pour les onglets de sélection de niveau d'entité
/// adapté aux responsables et suppléants de commissions
class CommissionScopeTabs extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onChanged;
  final bool showAllLevels;
  final EntityLevel? userEntityLevel;

  const CommissionScopeTabs({
    super.key,
    required this.selectedIndex,
    required this.onChanged,
    this.showAllLevels = true,
    this.userEntityLevel,
  });

  static const _accent = Color(0xFF0066CC);
  static const _textSecondary = Colors.white70;

  /// Génère les onglets en fonction du niveau d'entité de l'utilisateur
  List<Map<String, dynamic>> _generateScopes() {
    final allScopes = [
      {
        'label': 'Internationale',
        'level': EntityLevel.internationale,
        'icon': Icons.public,
      },
      {
        'label': 'Territoriale',
        'level': EntityLevel.territoriale,
        'icon': Icons.map,
      },
      {
        'label': 'Champ (KSO)',
        'level': EntityLevel.champ,
        'icon': Icons.location_on,
      },
      {
        'label': 'District',
        'level': EntityLevel.district,
        'icon': Icons.domain,
      },
      {
        'label': 'Communauté',
        'level': EntityLevel.communaute,
        'icon': Icons.church,
      },
    ];

    if (!showAllLevels && userEntityLevel != null) {
      // Filtrer les niveaux accessibles selon le niveau de l'utilisateur
      final userLevelIndex = _getLevelIndex(userEntityLevel!);
      return allScopes.sublist(0, userLevelIndex + 1);
    }

    return allScopes;
  }

  int _getLevelIndex(EntityLevel level) {
    switch (level) {
      case EntityLevel.internationale:
        return 0;
      case EntityLevel.territoriale:
        return 1;
      case EntityLevel.champ:
        return 2;
      case EntityLevel.district:
        return 3;
      case EntityLevel.communaute:
        return 4;
    }
  }

  @override
  Widget build(BuildContext context) {
    final scopes = _generateScopes();

    return Container(
      height: 50,
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: scopes.length,
        itemBuilder: (context, index) {
          final isSelected = selectedIndex == index;
          final scope = scopes[index];

          return GestureDetector(
            onTap: () => onChanged(index),
            child: Container(
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                color: isSelected ? _accent : Colors.transparent,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isSelected ? _accent : Colors.white24,
                  width: isSelected ? 2 : 1,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    scope['icon'] as IconData,
                    color: isSelected ? Colors.white : _textSecondary,
                    size: 14,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    scope['label'] as String,
                    style: TextStyle(
                      color: isSelected ? Colors.white : _textSecondary,
                      fontSize: 11,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

